//
//  systemsMenu3D.swift
//  desarrolloVision
//
//  Created by Eugenio Pedraza on 28/02/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct systemsMenu3D: View {
    @EnvironmentObject var sharedViewModel: SharedViewModel
    
    var bodySystems: BodySystem
    @State private var selectedAnatomy: BodySystem?
    @State private var bounce = false
    @State private var rotationAngle: CGFloat = 0
    @State var showModel: Bool = false
    @Environment(\.openWindow) var openWindow
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    
    var body: some View {
        NavigationSplitView{
            ScrollView {
                ForEach(arrBodySystems) {bodySystem in
                    BodyRow(bodySystem: bodySystem, onSelect: {selectedSystem in
                        self.selectedAnatomy = selectedSystem})
                }
                .navigationTitle("Systems")
            }

        } detail: {
            VStack(alignment: .leading){
                if let selectedAnatomy = selectedAnatomy {
                    Text(selectedAnatomy.name)
                        .font(.system(size: 40))
                        .fontWeight(.light)
                        .padding(15)
                    Divider()
                    ScrollView{
                        Text(selectedAnatomy.description)
                            .padding(25)
                        .font(.system(size: 30))}
                    HStack{
                        Spacer()
                        Button(action: {
                            switch selectedAnatomy.name{
                            case "Skeletal System":
                                openWindow(id: "skeletalModel")
                            case "Nervous System":
                                openWindow(id: "nervousModel")
                            case "Muscular System":
                                openWindow(id: "muscularModel")
                            case "Circulatory System":
                                openWindow(id: "circulatoryModel")
                            case "Respiratory System":
                                openWindow(id: "respiratoryModel")
                            default:
                                break
                            }
                        }) {
                            Text("> Display Model")
                                .monospaced()
                                .font(.system(size: 20, weight: .bold))
                        }
                        Button(action: {
                            if (selectedAnatomy.name == "Nervous System"){
                                Task {
                                    await openImmersiveSpace(id: "ImmersiveNervous")
                                }
                                openWindow(id: "nervousModel")
                            } else {
                                Task {
                                    await openImmersiveSpace(id: "Immersive")
                                }
                                openWindow(id: "ContentViewTest")
                            }
                            
                        }) {
                            Text("> Explore Model")
                                .monospaced()
                                .font(.system(size: 20, weight: .bold))
                        }
                        Spacer()
                    }
                    
                } else {
                    Text("Choose an Anatomy System")
                        .font(.system(size: 30))
                        .fontWeight(.light)
                        .padding(15)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
            .navigationTitle("Information")
        }
    }
    
}
    

#Preview(){
        systemsMenu3D(bodySystems: arrBodySystems[0])
}
