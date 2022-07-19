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
  func createPost(req: Request) async throws -> Post {
    // handle posting new post
    // need to get the user first but in theory we could save a post here
    // for testing purpose we will just add a new user to db
    let user = User(
      username: "TESTUSERFORDB",
      password: "",
      phone: ""
    )
    try await user.save(on: req.db)  //save the user to the database
    let post = Post(title: "TestPost")
    try await user.$posts.create(post, on: req.db)
    return post
  }

  func getPostById(req: Request) async throws -> Post {
    let id = try req.parameters.require("id") as UUID
    let post = try await Post.query(on: req.db)
      .filter(\.$id, .equal, id)
      .first()
    // handle get post by id
    guard let post = post else {
      throw Abort(.notFound)
    }
    return post
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
