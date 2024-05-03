//
//  MenuOptions.swift
//  desarrolloVision
//
//  Created by D Cantu on 01/03/24.
//

import Foundation

import Foundation

enum MenuOptions : String, Identifiable, CaseIterable, Equatable
{
    case about, learn, quiz
    var id : Self { self }
    var name: String { rawValue.lowercased() }
    
    var title : String {
        switch self {
        case.about:
            "VisionDoc is VR application for medicine students that enables the power of Spatial Computing for the education of the Anatomy of the Human Body"
        case.learn:
            ""
        case.quiz:
            ""
        }
    }
}
