import Fluent
import Vapor

final class Post: Model {
    static let schema = "posts"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Parent(key: "user_id")
    var user: User

    init() {}

    init(userId: User.IDValue, title: String) {
        self.$user.id = userId
    }

    init(title: String) {
        self.title = title
    }
}

extension Post: Content {}
