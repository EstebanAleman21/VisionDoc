//
//  RespiratoryModel.swift
//  VisionDoc
//
//  Created by Eugenio Pedraza on 14/03/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct RespiratoryModel: View {
    var body: some View {
        RealityView{ content in
            do {
                let scene =  try await Entity.init(named: "lungsAnatomy.usda", in: realityKitContentBundle)
                scene.position = SIMD3<Float>(x:0 , y:-0.13, z:0)
                scene.scale *= SIMD3<Float>(repeating:0.9)
                content.add(scene)
            } catch {
                logger.error("\(error.localizedDescription)")
            }
        }
        .installGestures()
    }
}

#Preview {
    RespiratoryModel()
}
