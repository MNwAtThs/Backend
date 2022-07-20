import Foundation

extension TimeInterval {
    static func minutes(_ value: TimeInterval) -> TimeInterval {
        return value * 60
    }

    static func hours(_ value: TimeInterval) -> TimeInterval {
        return value * minutes(60)
    }

    static func days(_ value: TimeInterval) -> TimeInterval {
        return value * hours(24)
    }

    static func years(_ value: TimeInterval) -> TimeInterval {
        return value * days(365)
    }
}
