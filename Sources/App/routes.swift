import Fluent
import Vapor

public func routes(_ app: Application) throws {
    try app.register(collection: AuthController())
    try app.register(collection: PostController())
    try app.register(collection: UserController())
}
