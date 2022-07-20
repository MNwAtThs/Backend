import Fluent
import Vapor

struct UserAuthenticator: AsyncBearerAuthenticator {
    typealias User = App.User

    func authenticate(
        bearer: BearerAuthorization,
        for request: Request
    ) async throws {

        // verify payload
        let payload = try request.application.jwt.signers
            .verify(bearer.token, as: UserTokenPayload.self)

        // find corresponding UserToken in db
        guard let token = try? await UserToken.find(payload.uuid, on: request.db),
            let user = try? await token.$user.get(on: request.db)
        else {
            throw Abort(.unauthorized)
        }

        // authenticate user if token is verified and valid
        request.auth.login(user)
    }
}
