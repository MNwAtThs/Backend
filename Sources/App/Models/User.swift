import Fluent
import Vapor

fileprivate enum Identifier {
    case uuid(UUID)
    case username(String)

    static func fromString(_ value: String) -> Self {
        if let value = UUID(uuidString: value) {
            return .uuid(value)
        } else {
            return .username(value)
        }
    }
}

final class User: Model {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "username")
    var username: String

    @Field(key: "password")
    var password: String

    @Field(key: "email")
    var email: String

    @Children(for: \.$user)
    var posts: [Post]

    init() {}

    init(id: UUID? = nil, username: String, email: String, password: String) {
        self.id = id
        self.username = username
        self.email = email
        self.password = password
    }

    static func findUserByIdOrUsername(_ identifierValue: String, on database: Database)
        async throws
        -> User?
    {
        let identifier = Identifier.fromString(identifierValue)
        return try await User.query(on: database).group {
            switch identifier {
            case .username(let username):
                $0.filter(\.$username, .equal, username)
            case .uuid(let uuid):
                $0.filter(\.$id, .equal, uuid)
            }
        }
        .limit(1)
        .first()
    }
}

extension User: Authenticatable {}
