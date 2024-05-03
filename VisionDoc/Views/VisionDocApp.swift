//
//  VisionDocApp.swift
//  VisionDoc
//
//  Created by Eugenio Pedraza on 14/03/24.
//

import SwiftUI
import os
import ARKit
import RealityKit
import RealityKitContent

public let logger = Logger()

@main
struct VisionDocApp: App {
    
    private let immersiveSpaceIdentifier = "Immersive"
    private let nervousModel = "ImmersiveNervous"
    @State private var viewModel = ViewModel()
    
    init(){
        RealityKitContent.GestureComponent
            .registerComponent()
        
        RealityKitContent.PointOfInterestComponent.registerComponent()
        PointOfInterestRuntimeComponent.registerComponent()
        RealityKitContent.TrailComponent.registerComponent()
        RealityKitContent.BillboardComponent.registerComponent()
        ControlledOpacityComponent.registerComponent()
        RealityKitContent.RegionSpecificComponent.registerComponent()
        
        RealityKitContent.BillboardSystem.registerSystem()
        RealityKitContent.TrailAnimationSystem.registerSystem()
    }
    
    var body: some SwiftUI.Scene {
        WindowGroup {
            ContentView()
        }
        
        WindowGroup(id: "ContentViewTest") {
            ContentViewTest(spaceId: immersiveSpaceIdentifier,
                        viewModel: viewModel)
        }
        .windowStyle(.plain)
        WindowGroup(id: "nervousModel") {
            ContentViewTest(spaceId: immersiveSpaceIdentifier,
                        viewModel: viewModel)
        }
        .windowStyle(.plain)
        
        WindowGroup(id: "skeletalModel"){
            SkeletalModel()
        } .windowStyle(.volumetric)
            .defaultSize(width: 10, height: 10, depth: 10, in: .meters)
        
        WindowGroup(id: "nervousModel"){
            NervousModel()
        } .windowStyle(.volumetric)
            .defaultSize(width: 10, height: 10, depth: 10, in: .meters)
        
        WindowGroup(id: "muscularModel"){
            MuscularModel()
        } .windowStyle(.volumetric)
            .defaultSize(width: 10, height: 10, depth: 10, in: .meters)
        
        WindowGroup(id: "circulatoryModel"){
            CirculatoryModel()
        } .windowStyle(.volumetric)
            .defaultSize(width: 10, height: 10, depth: 10, in: .meters)
        
        WindowGroup(id: "respiratoryModel"){
            RespiratoryModel()
        } .windowStyle(.volumetric)
            .defaultSize(width: 10, height: 10, depth: 10, in: .meters)
        
        ImmersiveSpace(id: immersiveSpaceIdentifier) {
            DioramaView(viewModel: viewModel)
        }
        .windowStyle(.automatic)
        ImmersiveSpace(id: nervousModel) {
            NervousDioramaView(viewModel: viewModel)
        }
        .windowStyle(.automatic)
    }
}
