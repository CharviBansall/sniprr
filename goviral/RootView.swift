//
//  RootView.swift
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            if !appState.hasCompletedOnboarding {
                OnboardingFlowView()
            } else {
                MainShellView()
            }
        }
    }
}

#Preview {
    Group {
        RootView()
            .environmentObject(AppState())

        RootView()
            .environmentObject({
                let state = AppState()
                state.hasCompletedOnboarding = true
                return state
            }())
    }
}
