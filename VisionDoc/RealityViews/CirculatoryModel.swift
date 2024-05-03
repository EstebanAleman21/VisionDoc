//
//  CirculatoryModel.swift
//  VisionDoc
//
//  Created by Eugenio Pedraza on 14/03/24.
//

import SwiftUI
import RealityKit
import RealityKitContent


struct CirculatoryModel: View {
    var body: some View {
        RealityView{ content in
            do {
                let scene =  try await Entity.init(named: "heartAnatomy.usda", in: realityKitContentBundle)
                scene.position = SIMD3<Float>(x:0 , y:0, z:0)
                scene.scale *= SIMD3<Float>(repeating:0.3)
                content.add(scene)
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