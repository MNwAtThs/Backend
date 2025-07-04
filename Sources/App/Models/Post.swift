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

    @Timestamp(key: "created_at", on: .create)
    var created_at: Date?

    @Children(for: \.$post)
    var comments: [Comment]

    init() {}

    init(userId: User.IDValue, title: String) {
        self.$user.id = userId
    }

    init(title: String) {
        self.title = title
    }
}

extension Post: Content {}
