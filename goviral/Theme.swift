import SwiftUI

struct Theme {
    // Primary accent color for prominent actions
    static let accent: Color = Color(red: 0.56, green: 0.0, blue: 0.8)

    // Core gradient colors used for the app background
    private static let gradientColors: [Color] = [
        Color.black,
        Color(red: 0.1, green: 0.0, blue: 0.15),
        Color(red: 0.2, green: 0.0, blue: 0.3)
    ]

    // Background gradient used throughout the app
    static var backgroundGradient: LinearGradient {
        LinearGradient(colors: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
