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
            AnatomyQuizView2()
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
                
                Text("breaking the boundaries of education")
                    .font(.title)
                    .foregroundColor(.white)
                    .shadow(radius: 5)

                Spacer()
                NavigationLink(destination: LearnView()) {
                      Text("> Begin your journey")
                          .monospaced()
                          .font(.system(size: 25, weight: .bold))
                          .foregroundColor(.white)
                          .padding()
                          .cornerRadius(10)
                }.navigationTitle("")
                Spacer()

            }
        }.clipShape(RoundedRectangle(cornerRadius: 30))
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
