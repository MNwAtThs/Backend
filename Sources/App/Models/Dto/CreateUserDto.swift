import Foundation

enum CreateUserDto {
    struct Request: Codable {
        let username: String
        let password: String
    }

    struct Response: Codable {
        let user: PublicUserDto
    }
}
