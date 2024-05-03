//
//  Anatomysystem2.swift
//  VisionDoc
//
//  Created by Esteban Aleman on 23/04/24.
//

import Foundation

import SwiftUI
import SceneKit
import Combine

struct AnatomySystem2: Identifiable {
    var id: Int
    var name: String
    var imageName: String
    var labels: [String]
    var dropZones: [DropZone2]
}

struct DropZone2: Codable {
    var label: String
    var positionX: CGFloat
    var positionY: CGFloat
    var width: CGFloat
    var height: CGFloat
}

class AnatomyQuizViewModel2: ObservableObject {
    @Published var systems: [AnatomySystem2]
    @Published var currentSystemIndex = 0

    init() {
        // Initialize with dummy data
        systems = [
            AnatomySystem2(id: 1, name: "Muscular System", imageName: "muscle.usdz", labels: ["Biceps", "Triceps"], dropZones: [
                DropZone2(label: "Biceps", positionX: 100, positionY: 200, width: 50, height: 50),
                DropZone2(label: "Triceps", positionX: 150, positionY: 250, width: 50, height: 50)
            ]),
            // Add more systems as needed
        ]
    }

    var currentSystem: AnatomySystem2 {
        systems[currentSystemIndex]
    }

    func moveToNextSystem() {
        if currentSystemIndex < systems.count - 1 {
            currentSystemIndex += 1
        }
    }
}
