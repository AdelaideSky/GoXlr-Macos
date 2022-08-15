//
//  CIHueSaturationValueGradientView.swift
//  Colour Wheel
//
//  Created by Christian P on 9/6/20.
//  Copyright © 2020 Christian P. All rights reserved.
//

extension NSImage {
    var CGImage: CGImage {
        get {
            let imageData = self.tiffRepresentation!
            let source = CGImageSourceCreateWithData(imageData as CFData, nil).unsafelyUnwrapped
            let maskRef = CGImageSourceCreateImageAtIndex(source, Int(0), nil)
            return maskRef.unsafelyUnwrapped
        }
    }
}

func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
    let context = CIContext(options: nil)
    if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
        return cgImage
    }
    return nil
}

import SwiftUI

/// This UIViewRepresentable uses `CIHueSaturationValueGradient` to draw a circular gradient with the RGB colour space as a CIFilter.
struct CIHueSaturationValueGradientView: NSViewRepresentable {
    
    /// Radius to draw
    var radius: CGFloat
    
    /// The brightness/value of the wheel.
    @Binding var brightness: CGFloat
    
    /// Image view that will hold the rendered CIHueSaturationValueGradient.
    let imageView = NSImageView()
    
    func makeNSView(context: Context) -> NSImageView {
        /// Render CIHueSaturationValueGradient and set it to the ImageView that will be returned.
        imageView.image = renderFilter()
        return imageView
    }
    
    func updateNSView(_ uiView: NSImageView, context: Context) {
        /// When the view updates eg. brightness changes, a new CIHueSaturationValueGradient will be generated.
        uiView.image = renderFilter()
    }
    
    /// Generate the CIHueSaturationValueGradient and output it as a UIImage.
    func renderFilter() -> NSImage {
        let filter = CIFilter(name: "CIHueSaturationValueGradient", parameters: [
            "inputColorSpace": CGColorSpaceCreateDeviceRGB(),
            "inputDither": 0,
            "inputRadius": radius * 0.4,
            "inputSoftness": 0,
            "inputValue": brightness
        ])!
        
        /// Output as UIImageView
        let size = NSSize(width: 150, height: 150)
        let cgimage = convertCIImageToCGImage(inputImage: filter.outputImage!)
        let image = NSImage(cgImage: cgimage!, size: size)
        return image
    }
}

struct CIHueSaturationValueGradientView_Previews: PreviewProvider {
    static var previews: some View {
        CIHueSaturationValueGradientView(radius: 350, brightness: .constant(1))
            .frame(width: 350, height: 350)
    }
}
