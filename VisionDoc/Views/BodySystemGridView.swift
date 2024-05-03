import SwiftUI
import SceneKit

struct BodySystemGridView: View {
    let bodySystems: [BodySystem]
    @Binding var selectedAnatomy: BodySystem?

    private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 16), count: 2)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(bodySystems, id: \.id) { system in
                    NavigationLink(destination: quizView(selectedAnatomy: system)) {
                        VStack {
                            SceneView(scene: loadModel(named: system.modelName), options: [.autoenablesDefaultLighting, .allowsCameraControl])
                                .frame(width: 300, height: 300)
                                .background(Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.bottom, 8)
                                .glassBackgroundEffect() // Apply glass background effect

                            Text(system.name)
                                .font(.largeTitle)
                                .foregroundColor(.primary)
                                .padding(.top, 8)
                        }
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5)
                        .shadow(radius: 20)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }

    func loadModel(named name: String) -> SCNScene? {
        let scene = try? SCNScene(named: name)
        scene?.background.contents = UIColor.clear
        return scene
    }
}

struct BodySystemGridView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleSystems = [
            BodySystem(id: 1, name: "Skeletal System", modelName: "bone.scn", description: "A detailed view of the skeletal system."),
            BodySystem(id: 2, name: "Muscular System", modelName: "muscle.usdz", description: "Overview of human muscle anatomy."),
            BodySystem(id: 3, name: "Nervous System", modelName: "nerve_cell.scn", description: "Insights into the nervous system.")
        ]

        // Assuming the usage of a State or Binding for selectedAnatomy
        BodySystemGridView(bodySystems: sampleSystems, selectedAnatomy: .constant(sampleSystems.first))
            .previewLayout(.sizeThatFits)
    }
}

struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

extension View {
    func glassBackgroundEffect() -> some View {
        self.background(
            VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                .edgesIgnoringSafeArea(.all)
        )
    }
}
