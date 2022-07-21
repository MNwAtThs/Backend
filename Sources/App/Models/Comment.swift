import Fluent
import Vapor

final class Comment: Model {
    static let schema = "comments"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "body")
    var body: String

    @Parent(key: "user_id")
    var user: User

    @Parent(key: "post_id")
    var post: Post

    @Timestamp(key: "created_at", on: .create)
    var created_at: Date?

    init() {}

    init(userId: User.IDValue, postId: Post.IDValue, body: String) {
        self.$user.id = userId
        self.$post.id = postId
        self.body = body
    }

    init(body: String) {
        self.body = body
    }
}

extension Comment: Content {}
