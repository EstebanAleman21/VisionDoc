//
//  VisionDocApp.swift
//  VisionDoc
//
//  Created by Eugenio Pedraza on 14/03/24.
//

import SwiftUI
import os
import ARKit
import RealityKitContent

public let logger = Logger()

@main
struct VisionDocApp: App {
    init(){
        RealityKitContent.GestureComponent
            .registerComponent()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        WindowGroup(id: "skeletalModel"){
            SkeletalModel()
        } .windowStyle(.volumetric)
            .defaultSize(width: 2, height: 2, depth: 2, in: .meters)
        
        WindowGroup(id: "nervousModel"){
            NervousModel()
        } .windowStyle(.volumetric)
            .defaultSize(width: 2, height: 2, depth: 2, in: .meters)
        WindowGroup(id: "muscularModel"){
            MuscularModel()
        } .windowStyle(.volumetric)
            .defaultSize(width: 2, height: 2, depth: 2, in: .meters)
        
        WindowGroup(id: "circulatoryModel"){
            CirculatoryModel()
        } .windowStyle(.volumetric)
            .defaultSize(width: 2, height: 2, depth: 2, in: .meters)
        WindowGroup(id: "respiratoryModel"){
            RespiratoryModel()
        } .windowStyle(.volumetric)
            .defaultSize(width: 2, height: 2, depth: 2, in: .meters)
        
        WindowGroup(id: "urinaryModel"){
            UrinaryModel()
        } .windowStyle(.volumetric)
            .defaultSize(width: 2, height: 2, depth: 2, in: .meters)
    }
}
