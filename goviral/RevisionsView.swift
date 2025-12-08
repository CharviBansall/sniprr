//
//  RevisionsView.swift
//  goviral
//
//  Created by GoViral Team.
//

import SwiftUI

struct RevisionsView: View {
    @EnvironmentObject var appState: AppState
    @State private var navigateToDetail: Revision? = nil

    var body: some View {
        ZStack(alignment: .bottom) {
            Theme.backgroundGradient.ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Your revisions")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal)
                            .padding(.top)

                        if appState.revisions.isEmpty {
                            EmptyStateCard()
                                .padding(.horizontal)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(appState.revisions) { rev in
                                    Button {
                                        navigateToDetail = rev
                                    } label: {
                                        RevisionCard(revision: rev)
                                    }
                                    .buttonStyle(.plain)
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.bottom, 80)
                        }
                    }
                    .padding(.bottom, 8)
                }

                // Sticky primary button
                PrimaryActionButton(title: "Create revision") {
                    let analysis = appState.currentVideoAnalysis ?? .mock
                    _ = appState.createRevision(from: analysis)
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
            }

            // Navigation to detail (stub)
            NavigationLink(
                isActive: Binding(
                    get: { navigateToDetail != nil },
                    set: { if !$0 { navigateToDetail = nil } }
                ),
                destination: {
                    Group {
                        if let rev = navigateToDetail {
                            RevisionDetailView(revision: rev)
                        } else {
                            EmptyView()
                        }
                    }
                },
                label: { EmptyView() }
            )
            .hidden()
        }
        .navigationTitle("Revisions")
#if os(iOS) || os(visionOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }
}

private struct EmptyStateCard: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundStyle(.white)
            Text("Create your first revision")
                .font(.headline)
            Text("Turn your analysis into an improved version with a stronger hook and caption.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
    }
}

private struct RevisionCard: View {
    let revision: Revision

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(revision.baseTitle)
                    .font(.headline)
                Text(timeAgo(since: revision.createdAt))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            ScoreCircle(score: revision.score)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.95))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.pink.opacity(0.35), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.08), radius: 3, y: 2)
    }

    private func timeAgo(since date: Date) -> String {
        let seconds = Int(Date().timeIntervalSince(date))
        if seconds < 60 { return "\(seconds)s ago" }
        let minutes = seconds / 60
        if minutes < 60 { return "\(minutes)m ago" }
        let hours = minutes / 60
        if hours < 24 { return "\(hours)h ago" }
        let days = hours / 24
        return "\(days)d ago"
    }
}

private struct ScoreCircle: View {
    let score: Int
    var body: some View {
        ZStack {
            Circle().stroke(Color.black.opacity(0.1), lineWidth: 8)
            Circle()
                .trim(from: 0, to: CGFloat(min(1, max(0, Double(score) / 100))))
                .stroke(AngularGradient(colors: [.pink, .purple, .mint], center: .center), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.snappy, value: score)
            Text("\(score)")
                .font(.subheadline.bold())
        }
        .frame(width: 48, height: 48)
    }
}

private struct RevisionDetailView: View {
    let revision: Revision
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Hook")
                    .font(.headline)
                Text(revision.newHook)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.05)))

                Text("Caption")
                    .font(.headline)
                Text(revision.newCaption)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.05)))
            }
            .padding()
        }
        .navigationTitle("Revision")
#if os(iOS) || os(visionOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
        .background(Theme.backgroundGradient.ignoresSafeArea())
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

#Preview {
    NavigationStack {
        RevisionsView()
            .environmentObject(AppState())
    }
}
