import SwiftUI

struct MainTabView: View {

    @StateObject private var favoritesVM = FavoritesViewModel()
    
    var body: some View {
        TabView {

            HomeView()
                .environmentObject(favoritesVM)
                .tabItem {
                    Image(systemName: "house.fill")
                }

            FavoritesView()
                
                .environmentObject(favoritesVM)
                .tabItem {
                    Image(systemName: "heart.fill")
                }
            
            DesignQuoteView(
                quote: Quote(
                    id: UUID(),
                    text: "Design is intelligence made visible.",
                    author: "Alina Wheeler",
                    category: "Design"
                )
            )
            .tabItem {
                Image(systemName: "book.closed.fill")
            }

            
        }
        .tint(.teal) // active icon color
    }
}
