//
//  AppState.swift
//

import Foundation
import Combine
import SwiftUI

final class AppState: ObservableObject {
    @Published var hasCompletedOnboarding: Bool = false
    @Published var currentVideoAnalysis: VideoAnalysis? = nil
    @Published var revisions: [Revision] = Revision.mockList

    init() {
        self.hasCompletedOnboarding = false
        self.currentVideoAnalysis = nil
    }

    func runMockAnalysis() {
        self.currentVideoAnalysis = .mock
        self.hasCompletedOnboarding = true
    }

    func createRevision(from analysis: VideoAnalysis) -> Revision {
        let new = Revision(
            id: UUID(),
            createdAt: Date(),
            baseTitle: analysis.title,
            newHook: "What if we told you there's a faster way?",
            newCaption: analysis.caption + " | New CTA: Save this for later!",
            score: min(100, analysis.viralityScore + Int.random(in: 1...6))
        )
        revisions.insert(new, at: 0)
        return new
    }
}
