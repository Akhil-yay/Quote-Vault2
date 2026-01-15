import SwiftUI

struct HomeView: View {

    // MARK: - Dependencies
    @EnvironmentObject var authVM: AuthViewModel
    @StateObject private var quoteVM = QuoteViewModel()
    @EnvironmentObject var favoritesVM: FavoritesViewModel
    @State private var searchText: String = ""
    @State private var quoteOfDay: Quote?

    // MARK: - UI State
    @State private var openSettings = false
    @State private var selectedCategory: String? = nil

    private let categories = [
        "All", "Motivation", "Love", "Success", "Wisdom", "Humor"
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        header
                        searchBar
                        categorySelector
                        trendingAuthors
                        popularTags
                        searchResultsHeader
                        quotesList
                    }
                    .padding()
                }
                .refreshable {
                    await quoteVM.refresh()
                }
                .onAppear {
                    Task {
                        quoteOfDay = QuoteOfDayManager.shared.quoteForToday(from: quoteVM.quotes)
                        await quoteVM.fetchQuotes()
                    }
                }
            }
            .navigationDestination(isPresented: $openSettings) {
                SettingsView()
                    .environmentObject(authVM)
            }
        }
    }
    

    // MARK: - Header
    private var header: some View {
        HStack {
            Text("Explore")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Spacer()

            Button {
                openSettings = true
            } label: {
                Image(systemName: "person.circle.fill")
                    .font(.title)
                    .foregroundColor(.gray)
            }
        }
    }

    // MARK: - Search Bar
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search quotes, authors, tags", text: $searchText)
                .foregroundColor(.white)
                .autocapitalization(.none)
                .disableAutocorrection(true)

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.08))
        .cornerRadius(14)
    }
    
    

    // MARK: - Category Selector
    private var categorySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    Text(category)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            selectedCategory == category ||
                            (category == "All" && selectedCategory == nil)
                            ? Color.teal
                            : Color.white.opacity(0.08)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .onTapGesture {
                            selectedCategory = category == "All" ? nil : category
                            Task {
                                await quoteVM.fetchQuotes(
                                    reset: true,
                                    category: selectedCategory
                                )
                            }
                        }
                }
            }
        }
    }

    // MARK: - Trending Authors
    private var trendingAuthors: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack {
                Text("Trending Authors")
                    .foregroundColor(.white)
                    .fontWeight(.semibold)

                Spacer()

                Text("SEE ALL")
                    .foregroundColor(.teal)
                    .font(.caption)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(trendingAuthorData, id: \.self) { author in
                        VStack {
                            Circle()
                                .fill(Color.white.opacity(0.15))
                                .frame(width: 56, height: 56)

                            Text(author)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Popular Tags
    private var popularTags: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Popular Tags")
                .foregroundColor(.white)
                .fontWeight(.semibold)

            WrapHStack(tags: popularTagData)
        }
    }

    // MARK: - Results Header
    private var searchResultsHeader: some View {
        HStack {
            Text("Quotes")
                .foregroundColor(.white)
                .fontWeight(.semibold)

            Spacer()

            Text("\(quoteVM.quotes.count) found")
                .foregroundColor(.gray)
                .font(.caption)
        }
    }

    // MARK: - Quotes List (SUPABASE POWERED)
    private var quotesList: some View {
        VStack(spacing: 16) {

            if quoteVM.isLoading && quoteVM.quotes.isEmpty {
                ProgressView()
                    .tint(.white)
            }

            if quoteVM.quotes.isEmpty && !quoteVM.isLoading {
                Text("No quotes found")
                    .foregroundColor(.gray)
            }

            ForEach(quoteVM.quotes) { quote in
                QuoteCardView(quote: quote)
                    .onAppear {
                        if quote == quoteVM.quotes.last {
                            Task {
                                await quoteVM.fetchQuotes(
                                    category: selectedCategory
                                )
                            }
                        }
                    }
            }

            if quoteVM.isLoading && !quoteVM.quotes.isEmpty {
                ProgressView()
                    .tint(.white)
            }
        }
    }
}

// MARK: - Supporting Data

let trendingAuthorData = [
    "M. Angelou",
    "A. Camus",
    "M. Aurelius",
    "S. Plath",
    "R. Emerson"
]

let popularTagData = [
    "#Stoicism",
    "#Minimalism",
    "#Poetry",
    "#Resilience",
    "#ModernClassic",
    "#Philosophy"
]

// MARK: - Wrap Layout
struct WrapHStack: View {
    let tags: [String]

    var body: some View {
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: 100))],
            spacing: 12
        ) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(20)
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    HomeView()
}
