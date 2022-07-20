import Fluent
import Vapor

final class User: Model {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "username")
    var username: String

    @Field(key: "password")
    var password: String

    // @Field(key: "phone")
    // var phone: String

    // @Field(key: "token")
    // var token: String?

    @Children(for: \.$user)
    var tokens: [UserToken]

    @Children(for: \.$user)
    var posts: [Post]

    init() {

    }

    init(id: UUID? = nil, username: String, password: String) {
        self.id = id
        self.username = username
        self.password = password
    }
}

extension User: Authenticatable {}
