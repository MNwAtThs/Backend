import Shared
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let group = routes.grouped("user")
        group.get(":id", use: getUser)
    }
}

extension UserController {
    func getUser(req: Request) async throws -> PaginatedDto<GetUserDto.Response> {
        let identifier = try req.parameters.require("id")

        let (page, limit) = req.pagination(prefix: "posts", defaultLimit: 100, maxLimit: 100)

        let user = try await User.findUserByIdOrUsername(identifier, on: req.db)
        guard let user = user else {
            throw Abort(.notFound)
        }

        let posts = try await user.$posts.query(on: req.db)
            .sort(\.$created_at, .descending)
            .page(withIndex: page, size: limit)
            .map { post -> PublicPostDto in
                let comment_count = try post.$comments.query(on: req.db).count().wait()
                return PublicPostDto(from: post, comment_count: comment_count)
            }

        return .init(
            data: GetUserDto.Response(user: .init(from: user), posts: posts.items),
            metadata: posts.metadata)
    }
}
