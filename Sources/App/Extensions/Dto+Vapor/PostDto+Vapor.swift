import Shared
import Vapor

extension PublicPostDto: Content {
    init(from: Post) {
        self.init(
            id: from.id!,
            user_id: from.$user.id,
            title: from.title,
            createdAt: from.created_at ?? Date()
        )
    }
}
