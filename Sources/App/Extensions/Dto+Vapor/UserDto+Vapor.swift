import Shared
import Vapor

extension PublicUserDto: Content {
    init(from: User) {
        self.init(id: from.id!, username: from.username)
    }
}
extension PrivateUserDto: Content {
    init(from: User) {
        self.init(id: from.id!, username: from.username, email: from.email)
    }
}
