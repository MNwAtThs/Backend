import Fluent
import FluentMongoDriver
import Vapor

/// Called before your application initializes.
public func configure(_ app: Application) throws {
    app.passwords.use(.bcrypt)
    try app.databases.use(.mongo(connectionString: "mongodb://localhost:27017/swift"), as: .mongo)
    try routes(app)
}
