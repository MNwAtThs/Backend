import Foundation

enum LoginDto {
    struct Request: Codable {
        let username: String
        let password: String
    }

    struct Response: Codable {
        let user: PublicUserDto
        let token: String
    }
}
