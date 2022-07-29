import Fluent
import Redis
import Vapor

protocol IPhoneAuth {
    var phonenumber: String { get }
    var code: String { get }
    var createdAt: Date { get }
    var expiresAt: Date { get }

}

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
        let redisSetKey: RedisKey = "usertokens:\(verified.subject.value)"
        guard
            let exists = try? await request.redis.sismember(bearer.token, of: redisSetKey).get(),
            exists,
            let uuid = UUID(uuidString: verified.subject.value),
            let user = try? await User.find(uuid, on: request.db)
        else {
            throw Abort(.unauthorized)
        }

        // authenticate user if token is verified and valid
        request.auth.login(user)
    }

}
