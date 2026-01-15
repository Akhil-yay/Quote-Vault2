import SwiftUI
import Supabase
import Combine

@MainActor
final class FavoritesViewModel: ObservableObject {

    @Published var favoriteQuotes: [Quote] = []
    @Published var isLoading = false

    private let client = SupabaseManager.shared.client

    // MARK: - Load favorites
    func loadFavorites(userId: UUID) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let response: [FavoriteRow] = try await client
                .from("favorites")
                .select("quote_id")
                .eq("user_id", value: userId)
                .execute()
                .value

            let ids = response.map { $0.quote_id }

            if ids.isEmpty {
                favoriteQuotes = []
                return
            }

            favoriteQuotes = try await client
                .from("quotes")
                .select()
                .in("id", values: ids)
                .execute()
                .value

        } catch {
            print("Failed to load favorites:", error)
        }
    }

    // MARK: - Toggle favorite
    func toggleFavorite(_ quote: Quote, userId: UUID) async {
        if isFavorite(quote) {
            await removeFavorite(quote, userId: userId)
        } else {
            await addFavorite(quote, userId: userId)
        }
    }

    func isFavorite(_ quote: Quote) -> Bool {
        favoriteQuotes.contains(quote)
    }

    // MARK: - Add
    private func addFavorite(_ quote: Quote, userId: UUID) async {
        do {
            try await client
                .from("favorites")
                .insert([
                    "user_id": userId,
                    "quote_id": quote.id
                ])
                .execute()

            favoriteQuotes.append(quote)

        } catch {
            print("Add favorite failed:", error)
        }
    }

    // MARK: - Remove
    private func removeFavorite(_ quote: Quote, userId: UUID) async {
        do {
            try await client
                .from("favorites")
                .delete()
                .eq("user_id", value: userId)
                .eq("quote_id", value: quote.id)
                .execute()

            favoriteQuotes.removeAll { $0 == quote }

        } catch {
            print("Remove favorite failed:", error)
        }
    }
}

// MARK: - Supabase Row Model
struct FavoriteRow: Codable {
    let quote_id: UUID
}
