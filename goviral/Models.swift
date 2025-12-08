//
//  VideoAnalysisModels.swift
//  Created on 2025-12-04
//

import Foundation

struct ImprovementSuggestion: Identifiable, Hashable {
    let id: UUID
    let title: String
    let tip: String
    let example: String
    
    init(id: UUID = UUID(), title: String, tip: String, example: String) {
        self.id = id
        self.title = title
        self.tip = tip
        self.example = example
    }
    
    static let mockSamples: [ImprovementSuggestion] = [
        ImprovementSuggestion(
            title: "Enhance Lighting",
            tip: "Use natural light or a ring light to improve video clarity and appeal.",
            example: "Film your video near a window during the day or position a ring light behind the camera."
        ),
        ImprovementSuggestion(
            title: "Add Captions",
            tip: "Include captions to make your video accessible and easy to follow without sound.",
            example: "Use apps or software to embed subtitles that highlight key points of your message."
        ),
        ImprovementSuggestion(
            title: "Engage Early",
            tip: "Hook viewers in the first 3 seconds to reduce drop-off rates.",
            example: "Start with a question or an intriguing statement to grab attention immediately."
        )
    ]
}

struct VideoAnalysis: Identifiable, Hashable {
    let id: UUID
    let title: String
    let caption: String
    let hashtags: [String]
    let viralityScore: Int
    let viewsRange: String
    let likesRange: String
    let sharesRange: String
    let improvements: [ImprovementSuggestion]
    
    static let mock = VideoAnalysis(
        id: UUID(),
        title: "Quick Morning Yoga Routine",
        caption: "Start your day energized with this 5-minute morning yoga flow. Perfect for all skill levels!",
        hashtags: ["#Yoga", "#MorningRoutine", "#Fitness", "#Wellness", "#HealthyHabits"],
        viralityScore: 78,
        viewsRange: "10K-15K",
        likesRange: "1.5K-2K",
        sharesRange: "300-500",
        improvements: [
            ImprovementSuggestion.mockSamples[0],
            ImprovementSuggestion.mockSamples[2]
        ]
    )
}

// MARK: - Revisions
struct Revision: Identifiable, Hashable {
    let id: UUID
    let createdAt: Date
    let baseTitle: String
    let newHook: String
    let newCaption: String
    let score: Int
}

extension Revision {
    static var mockList: [Revision] {
        let base = VideoAnalysis.mock
        let now = Date()
        return [
            Revision(
                id: UUID(),
                createdAt: now.addingTimeInterval(-60),
                baseTitle: base.title,
                newHook: "Start with: ‘You’re doing this wrong…’ for instant curiosity.",
                newCaption: base.caption + " | Try this twist for a stronger hook.",
                score: min(100, base.viralityScore + 3)
            ),
            Revision(
                id: UUID(),
                createdAt: now.addingTimeInterval(-3600),
                baseTitle: base.title,
                newHook: "Ask a bold question in the first 2 seconds.",
                newCaption: base.caption + " | Add a quick question to spark comments.",
                score: min(100, base.viralityScore + 5)
            ),
            Revision(
                id: UUID(),
                createdAt: now.addingTimeInterval(-86400),
                baseTitle: base.title,
                newHook: "Cut straight to the payoff, then show the steps.",
                newCaption: base.caption + " | Lead with the result, then explain.",
                score: min(100, base.viralityScore + 2)
            )
        ]
    }
}
