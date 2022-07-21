import Fluent
import Shared
import Vapor

extension PaginatedDto: Content {
    init(data: T, metadata: PageMetadata) {
        self.init(data: data, metadata: PageMetadataDto(from: metadata))
    }
}
