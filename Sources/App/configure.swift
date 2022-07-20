import Fluent
import FluentMongoDriver
import JWT
import Redis
import Vapor

/// Called before your application initializes.
public func configure(_ app: Application) throws {
    try app.databases.use(.mongo(connectionString: "mongodb://localhost:27017/swift"), as: .mongo)
    app.redis.configuration = try RedisConfiguration(hostname: "localhost")
    app.migrations.add(InitialMigration(), to: .mongo)
    try app.autoMigrate().wait()
    app.passwords.use(.bcrypt)

    // TODO: Change secret
    app.jwt.signers.use(.hs256(key: "verysecretkey"))
    try routes(app)
}
