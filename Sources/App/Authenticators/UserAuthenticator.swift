import Fluent
import Redis
import Vapor

struct UserAuthenticator: AsyncBearerAuthenticator {
    typealias User = App.User

    func authenticate(
        bearer: BearerAuthorization,
        for request: Request
    ) async throws {

        // verify payload
        let verified = try request.application.jwt.signers
            .verify(bearer.token, as: UserTokenPayload.self)

        // find corresponding UserToken in db
        let redisKey: RedisKey = "usertoken:\(bearer.token)"
        guard let exists = try? await request.redis.exists(redisKey).get(),
            exists > 0,
            let uuid = UUID(uuidString: verified.subject.value),
            let user = try? await User.find(uuid, on: request.db)
        else {
            throw Abort(.unauthorized)
        }

        // authenticate user if token is verified and valid
        request.auth.login(user)
    }
}
