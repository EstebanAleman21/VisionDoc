import SwiftUI
import RealityKit


struct QuizMenuView: View {
    @State private var selectedAnatomy: BodySystem? = nil
    @State private var bodySystems: [BodySystem] = []

    var body: some View {
            ScrollView {
                // Display the grid view
                BodySystemGridView(bodySystems: bodySystems, selectedAnatomy: $selectedAnatomy)
                    .onAppear {
                        loadBodySystems()
                    }
            }
    }

    private func loadBodySystems() {
        // Assuming this function fetches data from your API
        let url = URL(string: "http://localhost:3000/systems")!
        NetworkManager.shared.fetchData(url: url) { (result: Result<[BodySystem], Error>) in
            switch result {
            case .success(let systems):
                self.bodySystems = systems
            case .failure(let error):
                print("Failed to fetch systems: \(error)")
            }
        }
    }
}


