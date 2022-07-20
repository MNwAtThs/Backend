import Foundation
import Redis

extension RedisKey {

    enum IdType {
        case uuid(UUID)
        case string(String)
    }

    static func usertoken(_ userId: IdType) -> RedisKey {
        switch userId {
        case .uuid(let uuid):
            return "usertokens:\(uuid.uuidString)"
        case .string(let uuidString):
            return "usertokens:\(uuidString)"
        }
    }
}
