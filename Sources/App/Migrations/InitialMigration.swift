import Fluent

struct InitialMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("users")
            .id()
            .field("username", .string, .required)
            .unique(on: "username", name: "no_duplicate_username")
            .field("password", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        // Undo the change made in `prepare`, if possible.
    }
}
