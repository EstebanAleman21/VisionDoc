//
//  DifficultyButton.swift
//  desarrolloVision
//
//  Created by Alumno on 14/03/24.
//

import SwiftUI

struct DifficultyButton: View {
    var difficulty: Difficulty
    var action: () -> Void  // Closure to execute on tap

    var body: some View {
        Button(action: action) {
            Text(difficulty.rawValue)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}


