import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let group = routes.grouped("user")
        group.get(":id", use: getUserById)
        group.get(":id", "posts", use: getCommentsForUser)
    }
}

extension UserController {
    func getUserById(req: Request) async throws -> String {
        let id = try req.parameters.require("id")
        // handle get user by id
        return "get user by id: \(id)"
    }

    func getCommentsForUser(req: Request) async throws -> String {
        let id = try req.parameters.require("id")
        // handle get comments for user
        return "get comments for user id: \(id)"
    }
}