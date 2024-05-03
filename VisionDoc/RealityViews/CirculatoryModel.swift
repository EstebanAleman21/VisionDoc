import SwiftUI
import RealityKit
import RealityKitContent

struct CirculatoryModel: View {
    var body: some View {
        RealityView{ content in
            do {
                let scene = try await Entity.init(named: "heartAnimated.usda", in: realityKitContentBundle)
                scene.position = SIMD3<Float>(x: 0, y: -0.08, z: 0.003)
                scene.scale *= SIMD3<Float>(repeating: 0.1)
                content.add(scene)
                
                // Assuming the animation is attached to the entity and named "AnimationName"
                if let animation = scene.availableAnimations.first {
                    scene.playAnimation(animation.repeat(duration: .infinity), transitionDuration: 1.0, startsPaused: false)
                }
                
            } catch {
                logger.error("\(error.localizedDescription)")
            }
        }
        .installGestures()
    }
}

#Preview() {
    CirculatoryModel()
}
