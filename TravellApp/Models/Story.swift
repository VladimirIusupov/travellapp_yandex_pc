import Foundation

struct Story: Identifiable, Sendable {
    let id: UUID
    let imageName: String
    let title: String
    let subtitle: String
    var isViewed: Bool
    
    init(
        id: UUID = UUID(),
        imageName: String,
        title: String,
        subtitle: String,
        isViewed: Bool = false
    ) {
        self.id = id
        self.imageName = imageName
        self.title = title
        self.subtitle = subtitle
        self.isViewed = isViewed
    }
}
