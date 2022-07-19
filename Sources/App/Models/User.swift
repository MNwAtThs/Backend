import Fluent
import Vapor

final class User: Model {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    init() {}
}