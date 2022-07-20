import Fluent
import Vapor

struct UserAuthenticator: AsyncBearerAuthenticator {
    typealias User = App.User

    func authenticate(
        bearer: BearerAuthorization,
        for request: Request
    ) async throws {

        let payload = try request.application.jwt.signers
            .verify(bearer.token, as: UserTokenPayload.self)

        guard let token = try? await UserToken.find(payload.uuid, on: request.db),
            let user = try? await token.$user.get(on: request.db)
        else {
            throw Abort(.unauthorized)
        }

        request.auth.login(user)
    }
}
