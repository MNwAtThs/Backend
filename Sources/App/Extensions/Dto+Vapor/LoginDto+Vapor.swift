import Shared
import Vapor

extension LoginDto.Response: Content {}

extension LoginDto.Request: Validatable {
    public static func validations(_ validations: inout Validations) {
        CreateUserDto.Request.validations(&validations)
    }
}
