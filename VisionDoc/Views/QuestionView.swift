//
//  QuestionView.swift
//  VisionDoc
//
//  Created by Esteban Aleman on 11/04/24.
//
import SwiftUI

struct QuestionView: View {
    var difficulty: Difficulty
    var selectedAnatomy: BodySystem?
    @State private var questions: [Question] = []
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswerIndex: Int? = nil
    @State private var isQuizCompleted = false
    @State private var answerSubmitted = false
    @State private var score = 0
    @State private var userId: Int = UserDefaults.standard.integer(forKey: "userId")

    public var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    var body: some View {
        VStack {
            Spacer()
            if questions.isEmpty {
                Text("Loading questions...")
                    .onAppear {
                        loadQuizQuestions()
                    }
            } else if isQuizCompleted {
                VStack {
                    Text("Quiz completed! Your score: \(score)/\(questions.count)")
                        .font(.extraLargeTitle2)
                        .padding()
                    Button("Save Results") {
                        saveResults()
                    }
                    
                    Button("Restart Quiz") {
                        restartQuiz()
                    }
                    .buttonStyle(.bordered)
                    .padding()
                    
                    NavigationLink(destination: quizView(selectedAnatomy: selectedAnatomy)) {
                        Text("Return to Menu")
                    }
                    .buttonStyle(.bordered)
                    .padding()
                }
            } else {
                let question = questions[currentQuestionIndex]
                VStack(alignment: .center) {
                    Text(question.text)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding()

                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(question.answers.indices, id: \.self) { index in
                            AnswerButton(answer: question.answers[index].text,
                                         isSelected: self.selectedAnswerIndex == index,
                                         isCorrect: question.answers[index].isCorrect,
                                         isSubmitted: answerSubmitted,
                                         action: {
                                             if !answerSubmitted {
                                                 self.selectedAnswerIndex = index
                                             }
                                         })
                        }
                    }
                    .padding()

                    if answerSubmitted {
                        Text(question.answers[selectedAnswerIndex!].isCorrect ? "Correct!" : "Wrong!")
                            .foregroundColor(question.answers[selectedAnswerIndex!].isCorrect ? .green : .red)
                            .font(.largeTitle)
                            .transition(.scale)
                        
                        Button(currentQuestionIndex == questions.count - 1 ? "Finish" : "Next", action: handleNextQuestion)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    } else {
                        Button("Submit", action: {
                            submitAnswer()
                        })
                        .padding()
                        .background(selectedAnswerIndex != nil ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                        .disabled(selectedAnswerIndex == nil)
                    }

                    Spacer()
                }
            }
            Spacer()
        }
        .padding()
        .navigationBarTitle(Text("\(selectedAnatomy?.name ?? "Quiz") - \(difficulty.rawValue)"), displayMode: .inline)
    }
    
    private func handleNextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            selectedAnswerIndex = nil
            answerSubmitted = false
        } else {
            isQuizCompleted = true
        }
    }
    
    private func submitAnswer() {
        answerSubmitted = true
        if questions[currentQuestionIndex].answers[selectedAnswerIndex!].isCorrect {
            score += 1
        }
    }
    
    private func restartQuiz() {
        currentQuestionIndex = 0
        selectedAnswerIndex = nil
        isQuizCompleted = false
        answerSubmitted = false
        score = 0
        loadQuizQuestions()  // Optionally reload questions
    }
    
    private func saveResults() {
        guard let url = URL(string: "http://localhost:3000/quiz/results") else {
            print("Invalid URL")
            return
        }
        let body: [String: Any] = [
            "userId": userId,
            "quizId": selectedAnatomy?.id ?? 0,
            "score": score,
            "totalQuestions": questions.count
        ]
        guard let requestBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            print("Error: Could not encode result data to JSON")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error sending results: \(error.localizedDescription)")
                    // Update the UI to show an error message
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("No valid HTTP URL response received.")
                    return
                }
                switch httpResponse.statusCode {
                case 200:
                    // Assuming server returns JSON data
                    if let jsonData = data, let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
                        print("Results saved successfully: \(json)")
                        // Update the UI to show a success message
                    } else {
                        print("Results saved but no JSON message received.")
                    }
                case 400...499:
                    print("Client error: \(httpResponse.statusCode)")
                    if let jsonData = data, let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any], let message = json["message"] as? String {
                        print("Error message from server: \(message)")
                        // Update the UI to show this error message
                    }
                case 500...599:
                    print("Server error: \(httpResponse.statusCode)")
                    // Update the UI to show a server error message
                default:
                    print("Received unexpected HTTP status code: \(httpResponse.statusCode)")
                    // Handle unexpected status codes
                }
            }
        }.resume()
    }


    
    private func loadQuizQuestions() {
        guard let systemId = selectedAnatomy?.id, let url = URL(string: "http://localhost:3000/quiz/\(systemId)?difficulty=\(difficulty.rawValue)") else {
            print("Invalid URL or system ID")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decodedQuestions = try JSONDecoder().decode([Question].self, from: data)
                DispatchQueue.main.async {
                    self.questions = decodedQuestions
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }
}

struct AnswerButton: View {
    let answer: String
    var isSelected: Bool
    var isCorrect: Bool
    var isSubmitted: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "checkmark.circle")
                    .foregroundColor(isSubmitted && isSelected ? (isCorrect ? .green : .red) : .blue)
                    .font(.extraLargeTitle2)  // Larger icons
                Text(answer)
                    .foregroundColor(.white)
                    .fontWeight(.heavy)  // Bold text for better readability
                    .font(.title)  // Larger font size
            }
            .padding()  // Increase padding to enlarge button
            .frame(minWidth: 0, maxWidth: .infinity)  // Make button width expand to the maximum
            .background(isSelected ? (isSubmitted ? (isCorrect ? Color.green.opacity(0.2) : Color.red.opacity(0.2)) : Color.blue.opacity(0.2)) : Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
