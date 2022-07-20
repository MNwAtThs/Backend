import Foundation
import Vapor

enum LoginDto {
    struct Request: Codable {
        let username: String
        let password: String
    }

    struct Response: Content {
        let user: PublicUserDto
        let token: String
    }
}

extension LoginDto.Request: Validatable {
    static func validations(_ validations: inout Validations) {
        CreateUserDto.Request.validations(&validations)
    }
}
