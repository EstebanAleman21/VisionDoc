/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A representation of a single landmark.
*/

import Foundation
import SwiftUI
import CoreLocation
import SceneKit

// Es la estructura en la cual extrae los datos del JSON y los almacena en sus dependiendtes variables 
struct BodySystem: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var modelName: String
    var description: String
}
