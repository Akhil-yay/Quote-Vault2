import Foundation
import Supabase
import Combine

@MainActor
class QuoteViewModel: ObservableObject {

    @Published var quotes: [Quote] = []
    @Published var isLoading = false
    @Published var isRefreshing = false
    @Published var hasMore = true
    @Published var errorMessage: String?

    private let pageSize = 10
    private var offset = 0

    func fetchQuotes(reset: Bool = false, category: String? = nil) async {
        if reset {
            offset = 0
            quotes.removeAll()
            hasMore = true
        }

        guard hasMore else { return }

        isLoading = true

        do {
            var query = SupabaseManager.shared.client
                .from("quotes")
                .select()

            if let category {
                query = query.eq("category", value: category)
            }

            let response: [Quote] = try await query
                .range(from: offset, to: offset + pageSize - 1)
                .execute()
                .value

            quotes.append(contentsOf: response)
            offset += response.count
            hasMore = response.count == pageSize

        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func refresh() async {
        isRefreshing = true
        await fetchQuotes(reset: true)
        isRefreshing = false
    }
}
