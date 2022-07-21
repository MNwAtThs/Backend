import Shared
import Vapor

extension CreatePostDto {
    typealias Response = PublicPostDto
}

extension CreatePostDto.Request: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: .count(1...), required: true)
    }
}
