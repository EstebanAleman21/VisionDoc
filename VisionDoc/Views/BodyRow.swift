import SwiftUI

struct BodyRow: View {
    var bodySystem: BodySystem
    @State private var rotationAngle: CGFloat = 0
    var onSelect: (BodySystem) -> Void
    
    
    var body: some View {
        VStack(alignment: .center) {
            SceneKitModelView(modelName: bodySystem.modelName, rotationAngle: rotationAngle)
                .frame(width: 200, height: 200)
                .onTapGesture {
                    withAnimation(Animation.linear(duration: 2)) {
                        
                        rotationAngle += .pi * 2
                        
                    }
                    onSelect(bodySystem) // Con esta funcion cuando hagan el tap gesture se guardara el bodysystem seleccionado
                    
                    rotationAngle += .pi * 2 // Rotate 360 degrees
                }
            
        } .glassBackgroundEffect()
        
        Text(bodySystem.name)
            .minimumScaleFactor(0.1)
            .foregroundColor(.white)
            .fontWeight(.medium)
            .font(.largeTitle)
            .padding()
    }
} 


