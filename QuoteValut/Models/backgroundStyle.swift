import SwiftUI

enum BackgroundStyle: String, CaseIterable, Identifiable {
    case minimalist, nature, vibrant, monolith

    var id: String { rawValue }

    var title: String {
        rawValue.capitalized
    }

    var background: LinearGradient {
        switch self {
        case .minimalist:
            return LinearGradient(colors: [.teal, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .nature:
            return LinearGradient(colors: [.green, .black], startPoint: .top, endPoint: .bottom)
        case .vibrant:
            return LinearGradient(colors: [.pink, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .monolith:
            return LinearGradient(colors: [.black, .gray], startPoint: .top, endPoint: .bottom)
        }
    }
}
