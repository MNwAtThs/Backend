import Fluent
import Shared
import Vapor

extension PageMetadataDto: Content {
    public init(from: PageMetadata) {
        self.init(page: from.page, per: from.per, total: from.total, pageCount: from.pageCount)
    }
}
