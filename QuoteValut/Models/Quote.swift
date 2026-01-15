import Foundation

struct Quote: Identifiable, Codable,Equatable {
    let id: UUID
    let text: String
    let author: String
    let category: String
}
