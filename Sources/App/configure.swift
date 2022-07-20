import Fluent
import FluentMongoDriver
import Vapor

/// Called before your application initializes.
public func configure(_ app: Application) throws {
    try app.databases.use(.mongo(connectionString: "mongodb://localhost:27017/swift"), as: .mongo)
    app.migrations.add(InitialMigration(), to: .mongo)
    try app.autoMigrate().wait()
    app.passwords.use(.bcrypt)
    try routes(app)
}
