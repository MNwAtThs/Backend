import Shared
import Vapor

extension CreateUserDto.Response: Content {}

extension CreateUserDto.Request: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("username", as: String.self, is: .count(4...), required: true)
        validations.add("email", as: String.self, is: .email, required: true)
        validations.add("password", as: String.self, is: .count(6...), required: true)
    }
}
