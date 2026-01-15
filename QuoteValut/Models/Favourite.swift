import Foundation

struct Favorite: Identifiable, Codable {
    let id: UUID
    let user_id: UUID
    let quote_id: UUID
}
