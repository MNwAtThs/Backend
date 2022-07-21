import Shared
import Vapor

extension PublicUserDto: Content, Hashable {
    init(from: User) {
        self.init(id: from.id!, username: from.username)
    }

    public static func == (lhs: PublicUserDto, rhs: PublicUserDto) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}
extension PrivateUserDto: Content {
    init(from: User) {
        self.init(id: from.id!, username: from.username, email: from.email)
    }
}
