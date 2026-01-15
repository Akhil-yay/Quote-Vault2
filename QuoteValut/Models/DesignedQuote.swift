import Foundation

struct DesignedQuote: Identifiable, Codable {
    let id: UUID?
    let user_id: UUID
    let quote_text: String
    let author: String
    let category: String
    let background_style: String
    let font_size: Int
    let alignment: String
    let format: String
}
