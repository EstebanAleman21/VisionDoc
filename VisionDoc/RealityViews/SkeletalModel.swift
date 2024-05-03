//
//  View3DModel.swift
//  VisionDoc
//
//  Created by Eugenio Pedraza on 14/03/24.
//

import SwiftUI
import RealityKit
import RealityKitContent


struct SkeletalModel: View {
    @State private var rotateBy: Double = 0.0
    var body: some View {
        RealityView{ content in
            do {
                let scene =  try await Entity.init(named: "skeletonAnatomy.usda", in: realityKitContentBundle)
                scene.position = SIMD3<Float>(x:0 , y:-0.041 , z:0)
                scene.scale *= SIMD3<Float>(repeating:0.1)
                content.add(scene)
            } catch {
                logger.error("\(error.localizedDescription)")
            }
        }
        .installGestures()
            }
}

#Preview() {
    SkeletalModel()
}
