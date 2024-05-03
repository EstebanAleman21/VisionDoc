import SwiftUI
import SceneKit

struct AnatomyQuizView2: View {
    @State private var labelPositions: [String: CGPoint] = [
        "Right Arm": CGPoint(x: 100, y: 100),
        "Left Arm": CGPoint(x: 100, y: 200)
    ]
    @State private var isCorrectPlace: [String: Bool] = [
        "Right Arm": false,
        "Left Arm": false
    ]

    let dropZones: [String: CGRect] = [
        "Right Arm": CGRect(x: 800, y: 200, width: 150, height: 75),
        "Left Arm": CGRect(x: 300, y: 250, width: 150, height: 75)
    ]
    
    struct SceneKitView: UIViewRepresentable {
        let scene: SCNScene
        
        func makeUIView(context: Context) -> SCNView {
            let scnView = SCNView()
            scnView.scene = scene
            scnView.autoenablesDefaultLighting = true
            scnView.allowsCameraControl = true
            scnView.backgroundColor = UIColor.clear // Set the background color to clear

            // Scale the root node of the scene to make the model larger
            scnView.scene?.rootNode.childNodes.forEach { node in
                node.scale = SCNVector3(x: 1, y: 1, z: 1) // Adjust scale as needed
            }
            
            return scnView
        }
        
        func updateUIView(_ scnView: SCNView, context: Context) {
            // Update the view during state changes if necessary
        }
    }


    var body: some View {
        VStack {
            Text("Drag the labels to the correct organ")
                .padding()

            GeometryReader { geometry in
                ZStack {
                    SceneKitView(scene: SCNScene(named: "muscle.usdz") ?? SCNScene())
                                    .frame(width: 800, height: 800) // Set the desired frame for the SCNView
                                    .cornerRadius(10) // If you want rounded corners
                    // Draw drop zones
                    ForEach(dropZones.keys.sorted(), id: \.self) { key in
                        Rectangle()
                            .fill(isCorrectPlace[key] ?? false ? Color.green.opacity(0.5) : Color.white.opacity(0.2))
                            .frame(width: dropZones[key]?.width, height: dropZones[key]?.height)
                            .position(x: dropZones[key]!.midX, y: dropZones[key]!.midY)
                    }

                    // Display draggable labels
                    ForEach(Array(labelPositions.keys), id: \.self) { label in
                                Text(label)
                                    .padding()
                                    .background(isCorrectPlace[label] ?? false ? Color.green : Color.blue)
                                    .cornerRadius(5)
                                    .position(labelPositions[label]!)
                                    .gesture(
                                        DragGesture()
                                            .onChanged { gesture in
                                                self.labelPositions[label] = gesture.location
                                            }
                                            .onEnded { gesture in
                                                let dropZone = self.dropZones[label]!
                                                if dropZone.contains(gesture.location) {
                                                    withAnimation {
                                                        // Snap to the center of the drop zone
                                                        self.labelPositions[label] = CGPoint(x: dropZone.midX, y: dropZone.midY)
                                                        self.isCorrectPlace[label] = true
                                                    }
                                                } else {
                                                    self.isCorrectPlace[label] = false
                                                }
                                            }
                                    )
                            }
                            // ...
                        }
                        // Rest of your view
                    }
                }
            }
        }


struct AnatomyQuizView2_Previews: PreviewProvider {
    static var previews: some View {
        AnatomyQuizView2()
    }
}
