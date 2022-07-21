import Shared
import Vapor

extension PublicCommentDto: Content {
    init(from: Comment) {
        self.init(
            id: from.id!,
            user_id: from.$user.id,
            post_id: from.$post.id,
            body: from.body,
            created_at: from.created_at ?? Date()
        )
    }
}
