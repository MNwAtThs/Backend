import Vapor

extension Request {
    func pagination(
        prefix: String? = nil,
        defaultLimit: Int,
        maxLimit: Int
    ) -> (page: Int, limit: Int) {
        let prefix = prefix != nil ? "\(prefix!)_" : ""

        var page = (try? self.query.get(Int.self, at: "\(prefix)page")) ?? 1
        page = max(page, 1)

        var limit = (try? self.query.get(Int.self, at: "\(prefix)limit")) ?? defaultLimit
        limit = max(min(limit, maxLimit), 1)

        return (page, limit)
    }
}
