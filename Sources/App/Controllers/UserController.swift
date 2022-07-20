import Shared
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let group = routes.grouped("user")
        group.get(":id", use: getUser)
        group.get(":id", "posts", use: getPostsForUser)
    }
}

extension UserController {

    func getUser(req: Request) async throws -> PublicUserDto {
        let identifier = try req.parameters.require("id")
        let user = try await User.findUserByIdOrUsername(identifier, on: req.db)
        guard let user = user else {
            throw Abort(.notFound)
        }
        return .init(id: user.id!, username: user.username)
    }

    func getPostsForUser(req: Request) async throws -> [Post] {
        let identifier = try req.parameters.require("id")
        let user = try await User.findUserByIdOrUsername(identifier, on: req.db)
        guard let user = user else {
            throw Abort(.notFound)
        }
        let posts = try await user.$posts.get(on: req.db)
        return posts
    }
}
