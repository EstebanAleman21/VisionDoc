import SwiftUI
import _SceneKit_SwiftUI


struct quizView: View {
    let selectedAnatomy: BodySystem?
    
    var body: some View {
        VStack(spacing: 20) {
            Text(selectedAnatomy?.name ?? "Skeletal")
                .font(.system(size: 90))
                .fontWeight(.bold)
                .padding(20)
            Divider()

            Text("Choose a difficulty level:")
                .font(.extraLargeTitle)

            HStack {
                ForEach(Difficulty.allCases, id: \.self) { difficulty in
                    NavigationLink(destination: QuestionView(difficulty: difficulty, selectedAnatomy: selectedAnatomy)) {
                        Text(difficulty.rawValue)
                            .padding()
                            .frame(width: 250, height: 50)
                            .background(Color.clear)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .padding()
    }
}

struct quizView_Previews: PreviewProvider {
    static var previews: some View {
        let skeletalSystem = BodySystem(id: 1, name: "Skeletal", modelName: "skeleton.mdl", description: "Learn about bones.")
        quizView(selectedAnatomy: skeletalSystem)
    }
}

