import Vapor

struct UserController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let group = routes.grouped("user")
    group.get(":id", use: getUserById)
    group.get(":id", "posts", use: getPostsForUser)
  }
}

extension UserController {
  func getUserById(req: Request) async throws -> User {
    let id = try req.parameters.require("id") as UUID
    let user = try await User.find(id, on: req.db)
    guard let user = user else {
      throw Abort(.notFound)
    }
    return user
  }

  func getPostsForUser(req: Request) async throws -> [Post] {
    let id = try req.parameters.require("id") as UUID
    let user = try await User.find(id, on: req.db)
    guard let user = user else {
      throw Abort(.notFound)
    }
    let posts = try await user.$posts.get(on: req.db)
    return posts
  }
}
