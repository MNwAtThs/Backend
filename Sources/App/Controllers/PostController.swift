import Shared
import Vapor

struct PostController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let group = routes.grouped("posts")
        group.get(":id", use: getPostById)

        let protected = group.grouped(UserAuthenticator())
        protected.post("", use: createPost)
        protected.post(":id", "comments", use: createCommentForId)
    }
}

extension PostController {
    func createPost(req: Request) async throws -> Response {
        let body = try req.content.decode(CreatePostDto.Request.self)
        try CreatePostDto.Request.validate(content: req)

        let user = try req.auth.require(User.self)
        let post = Post(title: body.title)
        try await user.$posts.create(post, on: req.db)

        let dto = CreatePostDto.Response(
            user: PublicUserDto(from: user), post: PublicPostDto(from: post, comment_count: 0))

        let response: Response = .init(status: .created)
        try response.content.encode(dto)
        return response
    }

    func getPostById(req: Request) async throws -> PaginatedDto<GetPostDto.Response> {
        let id = try req.parameters.require("id") as UUID
        let post = try await Post.find(id, on: req.db)

        let (page, limit) = req.pagination(prefix: "comments", defaultLimit: 100, maxLimit: 100)

        guard let post = post else { throw Abort(.notFound) }

        let comments = try await post.$comments.query(on: req.db)
            .sort(\.$created_at, .descending)
            .with(\.$user)
            .page(withIndex: page, size: limit)

        var users = [String: PublicUserDto]()
        var commentDtos = [PublicCommentDto]()
        let user = try await post.$user.get(on: req.db)
        users[user.id!.uuidString] = PublicUserDto(from: user)

        comments.items.forEach {
            users[$0.$user.id.uuidString] = PublicUserDto(from: $0.user)
            commentDtos.append(PublicCommentDto(from: $0))
        }

        let comment_count = try await post.$comments.query(on: req.db).count()

        let dto: GetPostDto.Response = .init(
            post: PublicPostDto(from: post, comment_count: comment_count), users: users,
            comments: commentDtos)

        return .init(data: dto, metadata: comments.metadata)
    }

    func createCommentForId(req: Request) async throws -> Response {
        let body = try req.content.decode(CreateCommentDto.Request.self)
        try CreateCommentDto.Request.validate(content: req)

        let user = try req.auth.require(User.self)
        let id = try req.parameters.require("id") as UUID
        let post = try await Post.find(id, on: req.db)

        guard let post = post else { throw Abort(.notFound) }

        let comment_count = try await post.$comments.query(on: req.db).count()
        let comment = Comment(userId: user.id!, postId: post.id!, body: body.body)
        try await comment.save(on: req.db)

        let dto = CreateCommentDto.Response(
            user: PublicUserDto(from: user),
            post: PublicPostDto(from: post, comment_count: comment_count),
            comment: PublicCommentDto(from: comment))

        let response: Response = .init(status: .created)
        try response.content.encode(dto)
        return response
    }
}
