import SwiftUI

@MainActor
final class StoriesViewModel: ObservableObject {
    @Published var stories: [Story] = [
        Story(imageName: "story1",
              title: "Text Text Text Text Text Text Text Text Text Text",
              subtitle: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
              isViewed: false),
        
        Story(imageName: "story2",
              title: "Text Text Text Text Text Text Text Text Text Text",
              subtitle: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
              isViewed: false),
        
        Story(imageName: "story3",
              title: "Text Text Text Text Text Text Text Text Text Text",
              subtitle: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
              isViewed: false),
        
        Story(imageName: "story4",
              title: "Text Text Text Text Text Text Text Text Text Text",
              subtitle: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
              isViewed: false),
        
        Story(imageName: "story5",
              title: "Text Text Text Text Text Text Text Text Text Text",
              subtitle: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
              isViewed: false),
        
        Story(imageName: "story6",
              title: "Text Text Text Text Text Text Text Text Text Text",
              subtitle: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
              isViewed: false),
        
        Story(imageName: "story7",
              title: "Text Text Text Text Text Text Text Text Text Text",
              subtitle: "Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text Text",
              isViewed: false)
    ]
    
       @Published var showStories = false
       @Published var selectedIndex = 0
       
    
    func selectStory(at index: Int) {
        selectedIndex = index
        showStories = true
    }
    
    func markStoryViewed(at index: Int) {
        guard stories.indices.contains(index) else { return }
        stories[index].isViewed = true
    }
}
