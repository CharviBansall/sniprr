//
//  OnboardingFlowView.swift
//  goviral
//
//  Created by GoViral Team.
//

import SwiftUI

struct OnboardingFlowView: View {
    @EnvironmentObject var appState: AppState

    // MARK: - Steps & Selections
    enum OnboardingStep: Int, CaseIterable { case intro, creatorBasics, contentProfile, summary }

    enum ExperienceLevel: String, CaseIterable, Identifiable {
        case newbie, gettingHang, advanced, pro
        var id: String { rawValue }
        var title: String {
            switch self {
            case .newbie: return "Newbie"
            case .gettingHang: return "Getting the Hang"
            case .advanced: return "Advanced"
            case .pro: return "Pro"
            }
        }
        var subtitle: String {
            switch self {
            case .newbie: return "Just starting out on TikTok"
            case .gettingHang: return "Posting sometimes, learning the ropes"
            case .advanced: return "Consistent creator, wants to improve"
            case .pro: return "Seasoned creator optimizing for scale"
            }
        }
    }

    enum MainGoal: String, CaseIterable, Identifiable {
        case views, engagement, community, brandDeals, other
        var id: String { rawValue }
        var title: String {
            switch self {
            case .views: return "More Views"
            case .engagement: return "Higher Engagement"
            case .community: return "Grow Community"
            case .brandDeals: return "Brand Deals"
            case .other: return "Other"
            }
        }
        var subtitle: String {
            switch self {
            case .views: return "Boost reach and watch time"
            case .engagement: return "Increase likes, comments, shares"
            case .community: return "Build loyal followers"
            case .brandDeals: return "Attract sponsors and partnerships"
            case .other: return "Something else"
            }
        }
    }

    enum ContentCategory: String, CaseIterable, Identifiable, Hashable {
        case comedy = "😂 Comedy"
        case food = "🍔 Food"
        case travel = "🏖 Travel"
        case beauty = "💄 Beauty"
        case fitness = "💪 Fitness"
        case tech = "💻 Tech"
        case education = "📚 Education"
        case fashion = "👗 Fashion"
        case gaming = "🎮 Gaming"
        case music = "🎵 Music"
        case diy = "🛠 DIY"
        case finance = "💸 Finance"
        var id: String { rawValue }
        var label: String { rawValue }
    }

    enum Struggle: String, CaseIterable, Identifiable {
        case followers, engagement, reach, conversions, other
        var id: String { rawValue }
        var title: String {
            switch self {
            case .followers: return "Gaining followers"
            case .engagement: return "Low engagement"
            case .reach: return "Inconsistent reach"
            case .conversions: return "Converting views"
            case .other: return "Other"
            }
        }
        var subtitle: String {
            switch self {
            case .followers: return "Struggling to grow audience"
            case .engagement: return "Few likes/comments/shares"
            case .reach: return "Spikes and drops in performance"
            case .conversions: return "Hard to drive actions"
            case .other: return "Different challenge"
            }
        }
    }

    @State private var step: OnboardingStep = .intro

    @State private var experience: ExperienceLevel? = nil
    @State private var mainGoal: MainGoal? = nil
    @State private var categories: Set<ContentCategory> = []
    @State private var struggle: Struggle? = nil

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Theme.backgroundGradient
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Progress
                    ProgressBar(progress: progress)
                        .frame(height: 6)
                        .padding(.horizontal)
                        .padding(.top, 8)

                    // Content
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            content
                        }
                        .padding()
                    }
                    .scrollBounceBehavior(.basedOnSize)

                    // Sticky button
                    VStack(spacing: 8) {
                        Button(action: primaryAction) {
                            Text(primaryButtonTitle)
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Theme.accent)
                        .disabled(!isStepValid)
                        .padding(.horizontal)
                        .padding(.bottom, 12)
                    }
                    .background(.ultraThinMaterial)
                }
            }
            .navigationTitle(navigationTitle)
#if !os(macOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbar { toolbarContent }
        }
    }

    // MARK: - Derived
    private var progress: Double {
        let idx = Double(step.rawValue)
        let last = Double(OnboardingStep.allCases.count - 1)
        return max(0, min(1, idx / last))
    }

    private var primaryButtonTitle: String {
        switch step {
        case .intro: return "Get started"
        case .creatorBasics: return "Next"
        case .contentProfile: return "Next"
        case .summary: return "Finish setup"
        }
    }

    private var navigationTitle: String {
        switch step {
        case .intro: return "Welcome"
        case .creatorBasics: return "Creator basics"
        case .contentProfile: return "Content profile"
        case .summary: return "Summary"
        }
    }

    private var isStepValid: Bool {
        switch step {
        case .intro:
            return true
        case .creatorBasics:
            return experience != nil && mainGoal != nil
        case .contentProfile:
            return !categories.isEmpty && struggle != nil
        case .summary:
            return true
        }
    }

    // MARK: - Actions
    private func primaryAction() {
        switch step {
        case .intro:
            withAnimation { step = .creatorBasics }
        case .creatorBasics:
            guard isStepValid else { return }
            withAnimation { step = .contentProfile }
        case .contentProfile:
            guard isStepValid else { return }
            withAnimation { step = .summary }
        case .summary:
            appState.hasCompletedOnboarding = true
        }
    }

    // MARK: - Toolbar
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
#if os(macOS)
        ToolbarItem(placement: .navigation) {
            if step != .intro {
                Button(action: goBack) {
                    Label("Back", systemImage: "chevron.left")
                }
            }
        }
#else
        ToolbarItem(placement: .topBarLeading) {
            if step != .intro {
                Button(action: goBack) {
                    Label("Back", systemImage: "chevron.left")
                }
            }
        }
#endif
    }

    private func goBack() {
        switch step {
        case .intro: break
        case .creatorBasics: withAnimation { step = .intro }
        case .contentProfile: withAnimation { step = .creatorBasics }
        case .summary: withAnimation { step = .contentProfile }
        }
    }

    // MARK: - Content per step
    @ViewBuilder
    private var content: some View {
        switch step {
        case .intro:
            introView
        case .creatorBasics:
            creatorBasicsView
        case .contentProfile:
            contentProfileView
        case .summary:
            summaryView
        }
    }

    private var introView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Stop guessing. Start knowing. Upload your TikTok.")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)

            Text("GoViral analyzes your videos to reveal what’s working, what’s holding you back, and how to grow faster—backed by data, not guesswork.")
                .foregroundStyle(.white.opacity(0.9))
        }
    }

    private var creatorBasicsView: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Your creator profile")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                Text("Help us tailor insights to your experience and goals.")
                    .foregroundStyle(.white.opacity(0.9))
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Experience level")
                    .font(.headline)
                    .foregroundStyle(.white)

                ForEach(ExperienceLevel.allCases) { level in
                    SelectableCard(
                        title: level.title,
                        subtitle: level.subtitle,
                        selected: experience == level
                    ) {
#if canImport(UIKit)
                        UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.light).impactOccurred()
#endif
                        experience = level
                    }
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Main goal")
                    .font(.headline)
                    .foregroundStyle(.white)

                ForEach(MainGoal.allCases) { goal in
                    SelectableCard(
                        title: goal.title,
                        subtitle: goal.subtitle,
                        selected: mainGoal == goal
                    ) {
#if canImport(UIKit)
                        UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.light).impactOccurred()
#endif
                        mainGoal = goal
                    }
                }
            }
        }
    }

    private var contentProfileView: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Your content profile")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                Text("Pick what you create and the biggest challenge you face.")
                    .foregroundStyle(.white.opacity(0.9))
            }

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Categories (up to 4)")
                        .font(.headline)
                        .foregroundStyle(.white)
                    Spacer()
                    Text("\(categories.count)/4")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))
                }
                FlexibleChipGrid(
                    items: Array(ContentCategory.allCases),
                    selection: $categories,
                    maxSelection: 4
                ) { item, isSelected in
                    Text(item.label)
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Capsule().fill(isSelected ? Color.white.opacity(0.9) : Color.white.opacity(0.2))
                        )
                        .foregroundStyle(isSelected ? .black : .white)
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Biggest struggle")
                    .font(.headline)
                    .foregroundStyle(.white)

                ForEach(Struggle.allCases) { s in
                    SelectableCard(
                        title: s.title,
                        subtitle: s.subtitle,
                        selected: struggle == s
                    ) {
#if canImport(UIKit)
                        UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.light).impactOccurred()
#endif
                        struggle = s
                    }
                }
            }
        }
    }

    private var summaryView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("You're all set")
                .font(.title.bold())
                .foregroundStyle(.white)

            VStack(alignment: .leading, spacing: 8) {
                Label("Experience: \(experience?.title ?? "-")", systemImage: "person.fill")
                Label("Goal: \(mainGoal?.title ?? "-")", systemImage: "target")
                Label("Categories: \(categories.map { $0.label }.sorted().joined(separator: ", "))", systemImage: "square.grid.2x2")
                Label("Struggle: \(struggle?.title ?? "-")", systemImage: "exclamationmark.triangle")
            }
            .foregroundStyle(.white.opacity(0.95))

            Text("We'll personalize your analysis and tips based on what you shared. You can change these later in Settings.")
                .foregroundStyle(.white.opacity(0.85))
        }
    }
}

// MARK: - Progress Bar
private struct ProgressBar: View {
    let progress: Double // 0...1
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.white.opacity(0.2))
                Capsule()
                    .fill(Color.white)
                    .frame(width: max(0, min(1, progress)) * geo.size.width)
                    .animation(.easeInOut(duration: 0.25), value: progress)
            }
        }
    }
}

// MARK: - Selectable Card
private struct SelectableCard: View {
    let title: String
    var subtitle: String? = nil
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.black)
                    if let subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.black.opacity(0.7))
                    }
                }
                Spacer()
                if selected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.white.opacity(selected ? 0.95 : 0.85))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(selected ? Color.green.opacity(0.9) : Color.white.opacity(0.35), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Flexible Chip Grid
private struct FlexibleChipGrid<Item: Identifiable & Hashable, Content: View>: View {
    let items: [Item]
    @Binding var selection: Set<Item>
    let maxSelection: Int
    let content: (Item, Bool) -> Content

    init(items: [Item], selection: Binding<Set<Item>>, maxSelection: Int = Int.max, @ViewBuilder content: @escaping (Item, Bool) -> Content) {
        self.items = items
        self._selection = selection
        self.maxSelection = maxSelection
        self.content = content
    }

    var body: some View {
        let columns = [GridItem(.adaptive(minimum: 120), spacing: 12)]
        LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
            ForEach(items) { item in
                let isSelected = selection.contains(item)
                content(item, isSelected)
                    .onTapGesture {
#if canImport(UIKit)
                        UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.light).impactOccurred()
#endif
                        toggle(item)
                    }
            }
        }
    }

    private func toggle(_ item: Item) {
        if selection.contains(item) {
            selection.remove(item)
        } else {
            guard selection.count < maxSelection else { return }
            selection.insert(item)
        }
    }
}

#Preview {
    OnboardingFlowView()
        .environmentObject(AppState())
}
