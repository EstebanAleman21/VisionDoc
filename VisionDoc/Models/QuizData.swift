import Foundation

struct Question: Codable, Identifiable {
    var id: Int
    var text: String
    var answers: [Answer]
}

struct Answer: Codable, Identifiable {
    var id: Int
    var text: String
    var isCorrect: Bool
}
