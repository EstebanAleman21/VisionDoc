/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
App-specific extension on RealityView.
*/

import Foundation
import RealityKit
import SwiftUI

// MARK: - RealityView Extensions
public extension RealityView {
    
    func installGestures(location: Binding<Point3D>) -> some View {
        self
            .simultaneousGesture(
                DragGesture()
                    .targetedToAnyEntity()
                    .onChanged { value in
                        guard var gestureComponent = value.entity.gestureComponent else { return }
                        
                        gestureComponent.onChanged(value: value)
                        location.wrappedValue = value.location3D
                        
                        value.entity.components.set(gestureComponent)
                    }
                    .onEnded { value in
                        guard var gestureComponent = value.entity.gestureComponent else { return }
                        
                        gestureComponent.onEnded(value: value)
                        location.wrappedValue = value.location3D
                        
                        value.entity.components.set(gestureComponent)
                    }
            )
            .simultaneousGesture(
                MagnifyGesture()
                    .targetedToAnyEntity()
                    .onChanged { value in
                        guard var gestureComponent = value.entity.gestureComponent else { return }
                        
                        gestureComponent.onChanged(value: value)
                        location.wrappedValue = value.startLocation3D
                        
                        value.entity.components.set(gestureComponent)
                    }
                    .onEnded { value in
                        guard var gestureComponent = value.entity.gestureComponent else { return }
                        
                        gestureComponent.onEnded(value: value)
                        location.wrappedValue = value.startLocation3D
                        
                        value.entity.components.set(gestureComponent)
                    }
            )
            .simultaneousGesture(
                RotateGesture3D()
                    .targetedToAnyEntity()
                    .onChanged { value in
                        guard var gestureComponent = value.entity.gestureComponent else { return }
                        
                        gestureComponent.onChanged(value: value)
                        location.wrappedValue = value.startLocation3D
                        
                        value.entity.components.set(gestureComponent)
                    }
                    .onEnded { value in
                        guard var gestureComponent = value.entity.gestureComponent else { return }
                        
                        gestureComponent.onEnded(value: value)
                        location.wrappedValue = value.startLocation3D
                        
                        value.entity.components.set(gestureComponent)
                    }
            )
    }
    
    
    /// Apply this to a `RealityView` to pass gestures on to the component code.
    func installGestures() -> some View {
        simultaneousGesture(dragGesture)
            .simultaneousGesture(magnifyGesture)
            .simultaneousGesture(rotateGesture)
    }
    
    /// Builds a drag gesture.
    var dragGesture: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .useGestureComponent()
    }
    
    /// Builds a magnify gesture.
    var magnifyGesture: some Gesture {
        MagnifyGesture()
            .targetedToAnyEntity()
            .useGestureComponent()
    }
    
    /// Buildsa rotate gesture.
    var rotateGesture: some Gesture {
        RotateGesture3D()
            .targetedToAnyEntity()
            .useGestureComponent()
    }
}
