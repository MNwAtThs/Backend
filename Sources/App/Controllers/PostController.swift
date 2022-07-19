import Vapor

struct PostController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let group = routes.grouped("posts")
        group.post("", use: createPost)
        group.get(":id", use: getPostById)
        group.get(":id", "comments", use: getCommentsForId)
        group.post(":id", "comments", use: createCommentForId)
    }
}

extension PostController {
    func createPost(req: Request) async throws -> String {
        // handle posting new post
        return "create post"
    }

    func getPostById(req: Request) async throws -> String {
        let id = try req.parameters.require("id")
        // handle get post by id
        return "get post by id: \(id)"
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