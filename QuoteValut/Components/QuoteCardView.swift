import SwiftUI

struct QuoteCardView: View {

    let quote: Quote
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("“\(quote.text)”")
                .foregroundColor(.white)

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(quote.author)
                        .foregroundColor(.teal)
                        .font(.caption)

                    Text(quote.category.uppercased())
                        .foregroundColor(.gray)
                        .font(.caption2)
                }

                Spacer()
                Button {
                    Task {
                        guard let userId = authVM.userId else { return }
                        await favoritesVM.toggleFavorite(quote, userId: userId)
                    }
                } label: {
                    Image(systemName: favoritesVM.isFavorite(quote) ? "heart.fill" : "heart")
                        .foregroundColor(.teal)
                }

            }
        }
        .padding()
        .background(Color.white.opacity(0.08))
        .cornerRadius(16)
    }
}
