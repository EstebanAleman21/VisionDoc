//
//  modelViewTest.swift
//  desarrolloVision
//
//  Created by Eugenio Pedraza on 28/02/24.
//

import SwiftUI
import SceneKit

// Struct for SceneKit view 
struct SceneKitModelView: UIViewRepresentable {
    let modelName: String
    var rotationAngle: CGFloat

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.scene = SCNScene(named: modelName)
        scnView.autoenablesDefaultLighting = true
        scnView.backgroundColor = UIColor.clear
        return scnView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {

        let rotationAction = SCNAction.rotateBy(x: 0, y: rotationAngle, z: 0, duration: 10.0)
        uiView.scene?.rootNode.runAction(rotationAction)
    }
}

