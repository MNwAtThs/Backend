import Foundation
import JWT

struct UserTokenPayload: JWTPayload {
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case id = "jti"
    }

    var subject: SubjectClaim
    var id: IDClaim

    var uuid: UUID? {
        return UUID(uuidString: id.value)
    }

    init(subject: SubjectClaim) {
        self.subject = subject
        self.id = IDClaim(value: UUID().uuidString)
    }

    func verify(using signer: JWTSigner) throws {}
}
