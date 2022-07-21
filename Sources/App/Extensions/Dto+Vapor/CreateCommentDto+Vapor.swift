import Shared
import Vapor

extension CreateCommentDto.Response: Content {}

extension CreateCommentDto.Request: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("body", as: String.self, is: .count(1...), required: true)
    }
}
