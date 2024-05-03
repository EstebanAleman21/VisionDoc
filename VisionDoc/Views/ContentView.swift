//
//  ContentView.swift
//  VisionDoc
//
//  Created by Eugenio Pedraza on 14/03/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    var body: some View {
        ZStack {
            NavigationStack {
                MenuView()
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
