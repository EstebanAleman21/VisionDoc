import SwiftUI
import SceneKit

struct AnatomyQuizView: View {
    @ObservedObject var viewModel: QuizViewModel

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                quizContentView
            }
        }
        .onAppear {
            viewModel.loadSystems()
        }
        
    }

    private var quizContentView: some View {
        GeometryReader { geometry in
            HStack(spacing: 20) {
                labelColumn
                ZStack {
                    SceneKitView(sceneName: viewModel.currentSystem?.imageName ?? "")
                        .frame(width: 600, height: 600)
                        .cornerRadius(10)

                    dropZoneOverlay
                    labelViews
                }
                nextSystemButton
            }
        }
        .padding()
    }

    private var labelColumn: some View {
        VStack(alignment: .leading) {
            Text("Drag the labels to the correct organ")
                .font(.headline)
                .padding()
            ForEach(viewModel.currentSystem?.labels ?? [], id: \.self) { label in
                Text(label)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(5)
                    .frame(width: 200)
                    .opacity(viewModel.isLabelCorrect[label] ?? false ? 0 : 1) // Hide when placed correctly
            }
        }
        .frame(minWidth: 200, alignment: .leading) // Adjust width if needed
        .zIndex(1) // Make sure the label column is on top of the SceneKitView
    }

    private var dropZoneOverlay: some View {
        ForEach(viewModel.currentSystem?.dropZones ?? [], id: \.label) { zone in
            Rectangle()
                .fill(Color.white.opacity(0.2))
                .frame(width: zone.width, height: zone.height)
                .position(x: CGFloat(zone.positionX), y: CGFloat(zone.positionY))
                .zIndex(-1) // Ensure drop zones are behind the labels
        }
    }

    private var labelViews: some View {
        ForEach(viewModel.currentSystem?.labels ?? [], id: \.self) { label in
            labelView(label)
        }
    }

    private var nextSystemButton: some View {
        Button(action: {
                if viewModel.isQuizCompleted {
                   QuizTypeSelectionView()
                } else {
                    viewModel.moveToNextSystem()
                }
            }) {
                Text(viewModel.isLastSystem ? "Finish Quiz" : "Next System")
                    .bold()
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
    }

    private func labelView(_ label: String) -> some View {
        Text(label)
            .padding()
            .background(viewModel.isLabelCorrect[label] ?? false ? Color.green : Color.blue)
            .cornerRadius(5)
            .position(viewModel.labelPositions[label] ?? CGPoint(x: 100, y: 100))
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        viewModel.labelPositions[label] = gesture.location
                    }
                    .onEnded { gesture in
                        viewModel.finalizeLabelPosition(label: label, position: gesture.location)
                    }
            )
            .zIndex(2) // Ensures labels are always on top
    }
}

struct SceneKitView: UIViewRepresentable {
    let sceneName: String

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.autoenablesDefaultLighting = true
        scnView.allowsCameraControl = false
        scnView.backgroundColor = UIColor.clear
        scnView.accessibilityIdentifier = sceneName // Use accessibilityIdentifier to track the scene name
        loadScene(for: scnView, withName: sceneName)
        return scnView
    }

    func updateUIView(_ scnView: SCNView, context: Context) {
        // Check if the scene needs to be updated
        if scnView.accessibilityIdentifier != sceneName {
            loadScene(for: scnView, withName: sceneName)
            scnView.accessibilityIdentifier = sceneName
        }
    }

    private func loadScene(for scnView: SCNView, withName sceneName: String) {
        scnView.scene = SCNScene(named: sceneName) ?? SCNScene()
        setupCamera(scnView)
    }

    private func setupCamera(_ scnView: SCNView) {
        let cameraNode = scnView.scene?.rootNode.childNode(withName: "camera", recursively: true) ?? SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        scnView.scene?.rootNode.addChildNode(cameraNode)
    }
}


struct AnatomyQuizView_Previews: PreviewProvider {
    static var previews: some View {
        AnatomyQuizView(viewModel: QuizViewModel())
    }
}
