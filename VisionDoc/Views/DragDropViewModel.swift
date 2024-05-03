//
//  DragDropViewModel.swift
//  VisionDoc
//
//  Created by Esteban Aleman on 19/04/24.
//

import Foundation
import SwiftUI
import Combine

// Data structure for an anatomical system, labels, and drop zones.
struct AnatomySystem: Identifiable, Codable {
    var id: Int
    var name: String
    var imageName: String
    var labels: [String]
    var dropZones: [DropZone]

    enum CodingKeys: String, CodingKey {
        case id = "system_id"
        case name
        case imageName = "image_name"
        case labels
        case dropZones = "dropZones"
    }
}

struct DropZone: Codable {
    var label: String
    var positionX: Double
    var positionY: Double
    var width: Double
    var height: Double

    enum CodingKeys: String, CodingKey {
        case label
        case positionX = "position_x"
        case positionY = "position_y"
        case width
        case height
    }
}


struct LabelPosition: Identifiable {
    let id: String
    var position: CGPoint
    var isCorrect: Bool
}

// ViewModel managing the quiz logic.
class QuizViewModel: ObservableObject {
    @Published var systems: [AnatomySystem] = []
    @Published var currentSystemIndex = 0
    @Published var labelPositions: [String: CGPoint] = [:]
    @Published var isLabelCorrect: [String: Bool] = [:]
    @Published var isLoading = true
    @Published var isQuizCompleted = false
    
    
    var isLastSystem: Bool {
        currentSystemIndex == systems.count - 1
    }

    private var cancellables = Set<AnyCancellable>()
    
    var currentSystem: AnatomySystem? {
        guard systems.indices.contains(currentSystemIndex) else { return nil }
        return systems[currentSystemIndex]
    }

    init() {
        loadSystems()
    }

    func loadSystems() {
        guard let url = URL(string: "http://localhost:3000/anatomy") else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [AnatomySystem].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error: \(error)")
                    self.isLoading = false
                }
            }, receiveValue: { systems in
                self.systems = systems
                self.setupInitialPositions()
                self.isLoading = false
            })
            .store(in: &cancellables)
    }

    func setupInitialPositions() {
        guard let system = systems[safe: currentSystemIndex] else { return }
        var yOffset: CGFloat = 0 // Start at 0 and increment for each label
        let ySpacing: CGFloat = 75 // Space between labels

        labelPositions = system.labels.reduce(into: [:]) { result, label in
            result[label] = CGPoint(x: 100, y: 400 + yOffset)
            isLabelCorrect[label] = false
            yOffset += ySpacing // Increment the yOffset for the next label
        }
    }


    func finalizeLabelPosition(label: String, position: CGPoint) {
        guard let system = currentSystem else { return }

        // Find the drop zone that corresponds to the label
        if let zone = system.dropZones.first(where: { $0.label == label }) {
            // Create a CGRect for the drop zone
            let zoneRect = CGRect(x: zone.positionX, y: zone.positionY, width: zone.width, height: zone.height)
            
            // If the position is within the drop zone, update the label position and mark as correct
            if zoneRect.contains(position) {
                DispatchQueue.main.async {
                    // Set label position to the center of the drop zone
                    let center = CGPoint(x: zone.positionX + zone.width / 2, y: zone.positionY + zone.height / 2)
                    self.labelPositions[label] = center
                    self.isLabelCorrect[label] = true
                }
            } else {
                // If not in a drop zone, reset the position and mark as incorrect
                DispatchQueue.main.async {
                    self.isLabelCorrect[label] = false
                    // Optionally reset the label position if needed
                    // self.labelPositions[label] = initialPositionForLabel(label)
                }
            }
        }
    }





    
    var allLabelsCorrect: Bool {
        isLabelCorrect.values.allSatisfy { $0 }
    }

    func moveToNextSystem() {
        if currentSystemIndex < systems.count - 1 {
            currentSystemIndex += 1
            setupInitialPositions()
        } else {
            isQuizCompleted = true
        }
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

