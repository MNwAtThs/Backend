import Foundation
import JWT

struct UserTokenPayload: JWTPayload {
    static var expiration: Date {
        Date().advanced(by: .hours(1))
    }

    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
        case id = "jti"
    }

    var subject: SubjectClaim
    var expiration: ExpirationClaim
    var id: IDClaim

    var uuid: UUID? {
        return UUID(uuidString: id.value)
    }

    init(subject: SubjectClaim) {
        self.subject = subject
        self.expiration = ExpirationClaim(value: UserTokenPayload.expiration)
        self.id = IDClaim(value: UUID().uuidString)
    }

    func verify(using signer: JWTSigner) throws {
        try self.expiration.verifyNotExpired()
    }
}
