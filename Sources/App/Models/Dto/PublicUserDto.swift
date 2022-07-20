import Foundation
import Vapor

struct PublicUserDto: Codable, Content {
    let id: UUID
    let username: String
}
