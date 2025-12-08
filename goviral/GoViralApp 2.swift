//
//  GoViralApp.swift
//  GoViral
//
//  Created by GoViral Team.
//

import SwiftUI

@main
struct GoViralApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
        }
    }
}
