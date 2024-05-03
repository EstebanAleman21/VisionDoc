import SwiftUI

struct MenuView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            LearnView()
                .tabItem {
                    Label("Learn", systemImage: "book")
                }
            //AnatomyQuizView(viewModel: QuizViewModel())
           QuizTypeSelectionView()
                .tabItem {
                    Label("Quiz", systemImage: "questionmark.circle")
                }
            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person")
                }
            UserProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle.fill")
                }
        }
    }
}

struct HomeView: View {
    var body: some View {
        ZStack {
            // Background
            Image("menuimage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: 10)

            // Content
            VStack {
                Spacer()
                
                Text("VisionDoc")
                    .font(.system(size: 130))
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .shadow(radius: 10) // Add shadow for better readability
                
                Text("Explore Anatomy Like Never Before")
                    .font(.title)
                    .foregroundColor(.white)
                    .shadow(radius: 5)

                Spacer()

            }
        }
    }
}

struct LearnView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Body Systems")
                .font(.custom("monospace", size: 60))
                .fontWeight(.bold)
                .padding(.leading, 20)
                .padding(.top)
            systemsMenu3D(bodySystems: arrBodySystems[0])
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(.white)
        .cornerRadius(20)
    }
}

struct QuizView: View {
    var body: some View {
        VStack {
            Text("Quiz")
                .font(.custom("monospace", size: 60))
                .fontWeight(.bold)
                .padding(.leading, 20)
                .padding(.top)
            QuizMenuView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(.white)
        .cornerRadius(20)
    }
}



#Preview {
    MenuView()
}
