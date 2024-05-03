import SwiftUI

struct QuizTypeSelectionView: View {
    @State private var isDragAndDropQuizSelected = false
    @State private var isQuestionAnswerQuizSelected = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Select your type of quiz")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            HStack {
                NavigationLink(destination: AnatomyQuizView(viewModel: QuizViewModel()), isActive: $isDragAndDropQuizSelected) {
                    Text("Drag & Drop")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
                
                NavigationLink(destination: QuizMenuView(), isActive: $isQuestionAnswerQuizSelected) {
                    Text("Question & Answer")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
            }
            
            Spacer()
        }
        .padding()
        .navigationBarHidden(true)
    }
}

struct QuizTypeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        QuizTypeSelectionView()
    }
}
