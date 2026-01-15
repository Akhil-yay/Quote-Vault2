import SwiftUI

struct FavoritesView: View {
    
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    @EnvironmentObject var authVM: AuthViewModel
    
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if favoritesVM.favoriteQuotes.isEmpty {
                Text("No favorites yet")
                    .foregroundColor(.gray)
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(favoritesVM.favoriteQuotes) { quote in
                            QuoteCardView(quote: quote)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            Task {
                guard let userId = authVM.userId else { return }
                await favoritesVM.loadFavorites(userId: userId)
            }
        }
    }
    
}
