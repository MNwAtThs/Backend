import Fluent
import JWT
import Vapor

final class UserToken: Model {
    static let schema = "usertokens"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "user_id")
    var user: User

    @Field(key: "jwt")
    var jwt: String

    init() {}

    init(id: UUID? = nil, userId: User.IDValue, jwt: String) {
        self.id = id
        self.$user.id = userId
        self.jwt = jwt
    }
}
