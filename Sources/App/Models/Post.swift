import Fluent
import Vapor

final class Post: Model {
    static let schema = "posts"

    @ID(key: .id)
    var id: UUID?

    //no idea how the relationships are working for now
    // @Parent(key: "user_id")
    // var user: User

    @Field(key: "user_id")
    var userId: UUID

    init() {}

    init(userId: UUID) {
        self.userId = userId
    }
}

extension Post: Content {}