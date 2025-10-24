import SwiftUI

public struct Story: Identifiable, Hashable {
    public let id = UUID()
    public let imageName: String
    public let title: String
    public let subtitle: String
    public let duration: TimeInterval
}

public extension Story {
    static let mock: [Story] = [
        .init(imageName: "story1", title: "Text Text Text Text Text Text Text Text Text Text", subtitle: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text ", duration: 5),
        .init(imageName: "story2", title: "Text Text Text Text Text Text Text Text Text Text",       subtitle: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text ",   duration: 5),
        .init(imageName: "story3", title: "Text Text",             subtitle: "Text Text…",            duration: 5),
        .init(imageName: "story4", title: "Text",                  subtitle: "Text…",                 duration: 5)
    ]
}

/// Память о просмотренных историях
final class StoryStore: ObservableObject {
    @AppStorage("seenStoryIDs") private var seenIDsData: Data = Data()
    @Published private(set) var seen: Set<UUID> = []

    init() { seen = Self.decode(from: seenIDsData) }

    func markSeen(_ id: UUID) {
        if !seen.contains(id) {
            seen.insert(id)
            seenIDsData = Self.encode(seen)
        }
    }

    private static func encode(_ set: Set<UUID>) -> Data {
        (try? JSONEncoder().encode(Array(set))) ?? Data()
    }
    private static func decode(from data: Data) -> Set<UUID> {
        guard let arr = try? JSONDecoder().decode([UUID].self, from: data) else { return [] }
        return Set(arr)
    }
}
