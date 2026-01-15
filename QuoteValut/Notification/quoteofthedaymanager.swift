import Foundation

final class QuoteOfDayManager {

    static let shared = QuoteOfDayManager()
    private init() {}

    func quoteForToday(from quotes: [Quote]) -> Quote? {
        guard !quotes.isEmpty else { return nil }

        let today = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        let index = today % quotes.count
        return quotes[index]
    }
}
