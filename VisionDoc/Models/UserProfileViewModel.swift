import Foundation
class UserProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" // Adjust based on your actual format
            formatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter
        }()

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601  // Ensure this matches your date format
        return decoder
    }()

    func fetchUserProfile() {
        let userId = UserDefaults.standard.integer(forKey: "userId")
        guard userId != 0 else {
            errorMessage = "User ID not found"
            return
        }

        isLoading = true
        guard let url = URL(string: "http://localhost:3000/users/\(userId)/profile") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter) // Use the custom date formatter

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                guard let data = data, error == nil else {
                    self.errorMessage = "Network or server error: \(error?.localizedDescription ?? "Unknown error")"
                    return
                }

                do {
                    self.userProfile = try decoder.decode(UserProfile.self, from: data)
                } catch {
                    self.errorMessage = "Failed to decode user profile: \(error)"
                    print(String(data: data, encoding: .utf8) ?? "Invalid JSON data")
                }
            }
        }.resume()
    }




}


struct UserProfile: Codable {
    let userInfo: UserInfo
    let latestQuizResult: QuizResult?
}

struct UserInfo: Codable {
    let name: String
    let studentId: String

    enum CodingKeys: String, CodingKey {
        case name
        case studentId = "studentId"  // Adjusted to match JSON exactly
    }
}

struct QuizResult: Codable {
    let score: Int
    let totalQuestions: Int
    let dateTaken: Date

    enum CodingKeys: String, CodingKey {
        case score
        case totalQuestions
        case dateTaken = "dateTaken"
    }
}
