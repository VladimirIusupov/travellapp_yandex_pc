import Foundation

enum Route: Hashable, Sendable {
    case cityPicker(isFrom: Bool)
    case stationPicker(cityId: String, cityTitle: String, isFrom: Bool)
    case searchResults(fromCode: String, toCode: String, fromTitle: String, toTitle: String)
    case carrierInfo(code: String)
    case filters
}
