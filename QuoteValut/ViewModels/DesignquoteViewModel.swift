import SwiftUI
import Supabase
import Combine

@MainActor
final class DesignQuoteViewModel: ObservableObject {

    @Published var isSaving = false
    @Published var saveSuccess = false
    @Published var errorMessage: String?

    private let client = SupabaseManager.shared.client

    // MARK: - Save Designed Quote
    func saveDesignedQuote(
        userId: UUID,
        quote: Quote,
        style: BackgroundStyle,
        fontSize: CGFloat,
        alignment: TextAlignment,
        isSquare: Bool
    ) async {

        isSaving = true
        errorMessage = nil
        saveSuccess = false

        let payload = DesignedQuote(
            id: nil,
            user_id: userId,
            quote_text: quote.text,
            author: quote.author,
            category: quote.category,
            background_style: style.rawValue,
            font_size: Int(fontSize),
            alignment: alignmentString(from: alignment), 
            format: isSquare ? "square" : "story"
        )

        do {
            try await client
                .from("designed_quotes")
                .insert(payload)
                .execute()

            saveSuccess = true

        } catch {
            errorMessage = error.localizedDescription
        }

        isSaving = false
    }

    // MARK: - TextAlignment → String (FIX)
    private func alignmentString(from alignment: TextAlignment) -> String {
        switch alignment {
        case .leading:
            return "leading"
        case .center:
            return "center"
        case .trailing:
            return "trailing"
        @unknown default:
            return "center"
        }
    }
}
