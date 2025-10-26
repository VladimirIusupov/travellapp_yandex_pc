import Foundation

struct Filters: Equatable, Sendable {
    let morning: Bool
    let day: Bool
    let evening: Bool
    let night: Bool
    let transfers: Bool
}
