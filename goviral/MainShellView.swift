//
//  MainShellView.swift
//  GoViral 2.0
//
//  Created by Assistant on 2025-12-04.
//

import SwiftUI

struct MainShellView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack {
            HomeView()
        }
    }
}

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var navigateToSummary = false
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .ignoresSafeArea()
            VStack(spacing: 40) {
                Text("GoViral 2.0")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                Button(action: {
                    appState.runMockAnalysis()
                    navigateToSummary = true
                }) {
                    Text("Upload your next video")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
            }
            .padding()
        }
        .navigationDestination(isPresented: $navigateToSummary) {
            AnalysisSummaryView()
        }
    }
}

struct AnalysisSummaryView: View {
    @EnvironmentObject var appState: AppState
    @State private var navigateToRevisions = false
    @State private var appliedSuggestions: Set<UUID> = []

    private var analysis: VideoAnalysis {
        appState.currentVideoAnalysis ?? .mock
    }

    var body: some View {
        ZStack {
            Theme.backgroundGradient.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    VideoPreviewCard(title: analysis.title)

                    CaptionPreview(caption: analysis.caption, hashtags: analysis.hashtags)

                    SmartInsightsSection(score: analysis.viralityScore)

                    PredictedMetricsSection(views: analysis.viewsRange, likes: analysis.likesRange, shares: analysis.sharesRange)

                    ImprovementsList(
                        improvements: Array(analysis.improvements.prefix(3)),
                        applied: $appliedSuggestions
                    )

                    PrimaryActionButton(title: "Generate revision") {
                        navigateToRevisions = true
                    }
                }
                .padding()
            }
        }
        .navigationDestination(isPresented: $navigateToRevisions) {
            RevisionsPlaceholderView()
        }
        .navigationTitle("Analysis Summary")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

// MARK: - Components
private struct VideoPreviewCard: View {
    let title: String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.black.opacity(0.85))
                    .frame(height: 220)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 56, height: 56)
                    .foregroundStyle(.white.opacity(0.9))
            }
            Text(title)
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.horizontal, 4)
        }
        .padding()
        .background(.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
    }
}

private struct CaptionPreview: View {
    let caption: String
    let hashtags: [String]
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Caption & hashtags")
                .font(.title3.bold())
            Text(caption)
                .foregroundStyle(.secondary)
            WrapHashtagChips(hashtags: hashtags)
        }
        .padding()
        .background(.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
    }
}

private struct WrapHashtagChips: View {
    let hashtags: [String]
    var body: some View {
        let columns = [GridItem(.adaptive(minimum: 80), spacing: 8)]
        LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
            ForEach(hashtags, id: \.self) { tag in
                Text(tag)
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color.black.opacity(0.06)))
            }
        }
    }
}

private struct SmartInsightsSection: View {
    let score: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Smart insights")
                .font(.title3.bold())

            // Virality bar
            VStack(alignment: .leading, spacing: 8) {
                Text("Virality potential: \(score)/100")
                    .font(.subheadline)
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.black.opacity(0.06))
                        Capsule().fill(gradient(for: score))
                            .frame(width: CGFloat(score) / 100 * geo.size.width)
                            .animation(.snappy, value: score)
                    }
                }
                .frame(height: 10)
            }

            // Badges (placeholder logic)
            HStack(spacing: 8) {
                InsightBadge(title: "Hook", value: score < 50 ? "Weak" : (score < 75 ? "Medium" : "Strong"))
                InsightBadge(title: "Replay", value: score < 40 ? "Low" : (score < 70 ? "Medium" : "High"))
                InsightBadge(title: "Completion", value: score < 45 ? "Low" : (score < 80 ? "Medium" : "High"))
            }
        }
        .padding()
        .background(.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
    }

    private func gradient(for score: Int) -> LinearGradient {
        let colors: [Color]
        switch score {
        case 0..<40: colors = [.red.opacity(0.8), .orange]
        case 40..<70: colors = [.orange, .yellow]
        default: colors = [.green, .mint]
        }
        return LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
    }
}

private struct InsightBadge: View {
    let title: String
    let value: String
    var body: some View {
        HStack(spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.caption.bold())
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(Capsule().fill(Color.black.opacity(0.06)))
    }
}

private struct PredictedMetricsSection: View {
    let views: String
    let likes: String
    let shares: String
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Predicted metrics")
                .font(.title3.bold())
            HStack(spacing: 12) {
                MetricCard(title: "Views", value: views, badge: "Est.")
                MetricCard(title: "Likes", value: likes, badge: "Est.")
                MetricCard(title: "Shares", value: shares, badge: "Est.")
            }
        }
        .padding()
        .background(.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
    }
}

private struct MetricCard: View {
    let title: String
    let value: String
    var badge: String? = nil
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let badge { Text(badge).font(.caption2).padding(4).background(Capsule().fill(Color.black.opacity(0.06))) }
            Text(title).font(.subheadline).foregroundStyle(.secondary)
            Text(value).font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 3, y: 2)
    }
}

private struct ImprovementsList: View {
    let improvements: [ImprovementSuggestion]
    @Binding var applied: Set<UUID>

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Top improvements")
                .font(.title3.bold())
            VStack(spacing: 12) {
                ForEach(improvements) { item in
                    ImprovementCard(
                        item: item,
                        isApplied: applied.contains(item.id)
                    ) {
                        if applied.contains(item.id) {
                            applied.remove(item.id)
                        } else {
                            applied.insert(item.id)
                        }
                        print("Apply suggestion: \(item.title)")
                    }
                }
            }
        }
        .padding()
        .background(.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
    }
}

private struct ImprovementCard: View {
    let item: ImprovementSuggestion
    let isApplied: Bool
    let onApply: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(item.title)
                    .font(.headline)
                Spacer()
                if isApplied {
                    Text("Applied")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Color.green.opacity(0.15)))
                }
            }
            Text(item.tip)
                .foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 6) {
                Text("Example")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                Text(item.example)
                    .font(.subheadline)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.black.opacity(0.05)))
            }
            PrimaryActionButton(title: isApplied ? "Undo" : "Apply suggestion", style: .secondary, action: onApply)
                .animation(.snappy, value: isApplied)
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 3, y: 2)
    }
}

private struct PrimaryActionButton: View {
    enum Style { case primary, secondary }
    let title: String
    var style: Style = .primary
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .buttonStyle(.borderedProminent)
        .tint(style == .primary ? Theme.accent : .gray.opacity(0.6))
    }
}

private struct RevisionsPlaceholderView: View {
    var body: some View {
        Text("Revisions coming soon…")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.backgroundGradient.ignoresSafeArea())
    }
}

#Preview {
    MainShellView()
        .environmentObject(AppState())
}
