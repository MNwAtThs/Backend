import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let group = routes.grouped("user")
        group.get(":id", use: getUserById)
        group.get(":id", "posts", use: getPostsForUser)
    }
}

extension UserController {
    func getUserById(req: Request) async throws -> String {
        let id = try req.parameters.require("id")
        // handle get user by id
        return "get user by id: \(id)"
    }

    func getPostsForUser(req: Request) async throws -> String {
        let id = try req.parameters.require("id")
        // handle get posts for user
        return "get posts for user id: \(id)"
    }
}