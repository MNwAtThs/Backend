import Fluent
import Vapor

final class User: Model {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "username")
    var username: String

    @Children(for: \.$user)
    var posts: [Post]

    init() {
        
    }

    init(username: String) {
        self.username = username
    }
}

extension User: Content {}