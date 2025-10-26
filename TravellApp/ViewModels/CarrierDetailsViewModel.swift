import Foundation
import SwiftUI

@MainActor
final class CarrierDetailsViewModel: ObservableObject, Identifiable {
    let segment: Components.Schemas.Segment
    
    init(segment: Components.Schemas.Segment) {
        self.segment = segment
    }
    
    var id: String {
        segment.thread?.uid ?? UUID().uuidString
    }
    
    var carrierTitle: String {
        segment.thread?.carrier?.title ?? "Без названия"
    }
    
    var hasTransfersText: String? {
        if let hasTransfers = segment.has_transfers, hasTransfers {
            return "С пересадкой"
        }
        return nil
    }
    
    var transportIcon: String {
        switch segment.thread?.transport_type {
        case "plane": "airplane"
        case "train": "train.side.front.car"
        case "suburban": "tram.fill"
        case "bus": "bus"
        case "water": "ferry"
        case "helicopter": "helicopter"
        default: "questionmark.circle"
        }
    }
    
    var logoURL: URL? {
        if let logo = segment.thread?.carrier?.logo {
            return URL(string: logo)
        }
        return nil
    }
    
    var departureDateText: String? {
        guard let dep = segment.departure else { return nil }
        return CarrierDetailsViewModel.shortDateFormatter.string(from: dep)
    }
    
    var departureTimeText: String? {
        guard let dep = segment.departure else { return nil }
        return CarrierDetailsViewModel.timeFormatter.string(from: dep)
    }
    
    var arrivalTimeText: String? {
        guard let arr = segment.arrival else { return nil }
        return CarrierDetailsViewModel.timeFormatter.string(from: arr)
    }
    
    var durationText: String? {
        guard let duration = segment.duration else { return nil }
        let minutes = duration / 60
        let hours = minutes / 60
        let mins = minutes % 60
        return hours > 0 ? "\(hours) ч \(mins) мин" : "\(mins) мин"
    }
}

// MARK: - Formatters
extension CarrierDetailsViewModel {
    static let shortDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ru_RU")
        f.setLocalizedDateFormatFromTemplate("d MMMM")
        return f
    }()
    
    static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        f.locale = Locale(identifier: "ru_RU")
        return f
    }()
}

