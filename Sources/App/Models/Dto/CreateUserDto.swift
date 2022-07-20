import Foundation
import Vapor

enum CreateUserDto {
    struct Request: Codable {
        let username: String
        let password: String
    }

    struct Response: Content {
        let user: PublicUserDto
    }
}

extension CreateUserDto.Request: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("username", as: String.self, is: .count(4...))
        validations.add("password", as: String.self, is: .count(6...))
    }
}
