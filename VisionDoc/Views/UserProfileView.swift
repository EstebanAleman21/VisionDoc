import SwiftUI

struct UserProfileView: View {
    @ObservedObject var viewModel = UserProfileViewModel()

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                ScrollView {
                    userProfileContent
                }
            }
        }
        .onAppear {
            viewModel.fetchUserProfile()
        }
    }

    private var userProfileContent: some View {
        Group {
            if let userProfile = viewModel.userProfile {
                VStack(alignment: .leading, spacing: 20) {
                    profileHeader(name: userProfile.userInfo.name)
                    

                    infoSection(title: "Student ID", value: userProfile.userInfo.studentId, symbolName: "number")

                    if let quizResult = userProfile.latestQuizResult {
                        resultSection(result: quizResult)
                    } else {
                        Text("No quiz results available.")
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                Text("No user profile data available.")
                    .foregroundColor(.secondary)
            }
        }
    }

    private func profileHeader(name: String) -> some View {
        HStack {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)

            Text(name)
                .font(.system(.extraLargeTitle)) // Making the name larger
                .fontWeight(.bold)
        }
        .padding(20)
    }

    private func infoSection(title: String, value: String, symbolName: String) -> some View {
        HStack {
            Label(title, systemImage: symbolName)
                .font(.headline)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .padding()
        .cornerRadius(20)
        .shadow(radius: 3)
    }

    private func resultSection(result: QuizResult) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Latest Quiz Score:")
                .fontWeight(.bold)

            Text("\(result.score)/\(result.totalQuestions) - \(dateFormatter.string(from: result.dateTaken))")
                .font(.title) // Making the quiz score larger
        }
        .padding()
        .frame(maxWidth: .infinity) // Making the box take the full width available
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
        .padding() // Adding padding around the box to make it stand out more
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
