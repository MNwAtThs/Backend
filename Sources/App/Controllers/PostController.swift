import Shared
import Vapor

struct PostController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let group = routes.grouped("posts")
        group.get(":id", use: getPostById)
        group.get(":id", "comments", use: getCommentsForId)
        group.post(":id", "comments", use: createCommentForId)

        let protected = group.grouped(UserAuthenticator())
        protected.post("", use: createPost)
    }
}

extension PostController {
    func createPost(req: Request) async throws -> CreatePostDto.Response {
        let body = try req.content.decode(CreatePostDto.Request.self)
        try CreatePostDto.Request.validate(content: req)

        let user = try req.auth.require(User.self)
        let post = Post(title: body.title)
        try await user.$posts.create(post, on: req.db)
        return .init(from: post)
    }

    func getPostById(req: Request) async throws -> PublicPostDto {
        let id = try req.parameters.require("id") as UUID
        let post = try await Post.query(on: req.db)
            .filter(\.$id, .equal, id)
            .first()
        // handle get post by id
        guard let post = post else {
            throw Abort(.notFound)
        }
        return .init(from: post)
    }

    func getCommentsForId(req: Request) async throws -> String {
        let id = try req.parameters.require("id")
        // handle get comments for id
        return "get comments for id: \(id)"
    }

    func createCommentForId(req: Request) async throws -> String {
        let id = try req.parameters.require("id")
        // handle create comment for id
        return "create comment for id: \(id)"
    }
}
