import Fluent
import FluentMongoDriver
import MongoKitten

struct InitialMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("users")
            .id()
            .field("username", .string, .required)
            .unique(on: "username", name: "no_duplicate_username")
            .field("password", .string, .required)
            .create()

        // Index creation: a bit stupid its not build into fluent directly

        // guard let db = (database as? MongoDatabaseRepresentable)?.raw else {
        //     return
        // }
        // var keys = Document()
        // keys["title"] = SortOrder.ascending.rawValue
        // try await db["posts"]
        //     .createIndex(named: "_title_", keys: keys)
        //     .get()
    }

    func revert(on database: Database) async throws {
        try await database.schema("users")
            .deleteUnique(on: "username")
            .deleteField("username")
            .deleteField("password")
            .update()
    }
}
