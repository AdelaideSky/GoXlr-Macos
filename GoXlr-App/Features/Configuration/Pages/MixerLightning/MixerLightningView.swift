//
//  MixerLightningView.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 24/04/2023.
//

import SwiftUI
import Wallpaper
import DominantColor
import GoXlrKit

struct MixerLightningView: View {
    
    func getWallpaper() -> [URL: [NSColor]] {
        do {
            var url = try Wallpaper.get(screen: .main).first!
            var image = NSImage(data: try Data(contentsOf: url))!
            var colours = image.dominantColors()
//            GoXlr.shared.command(.SetAllFaderColours(colours[0].hexString, colours[1].hexString))
//            GoXlr.shared.command(.SetSimpleColour(.Scribble1, colours[0].hexString))
//            GoXlr.shared.command(.SetSimpleColour(.Scribble2, colours[0].hexString))
//            GoXlr.shared.command(.SetSimpleColour(.Scribble3, colours[0].hexString))
//            GoXlr.shared.command(.SetSimpleColour(.Scribble4, colours[0].hexString))
//            GoXlr.shared.command(.SetButtonGroupColours(.EffectSelector, colours[3].hexString, colours[3].hexString))
//            GoXlr.shared.command(.SetButtonGroupColours(.FaderMute, colours[3].hexString, colours[3].hexString))
//            GoXlr.shared.command(.SetButtonGroupColours(.SampleBankSelector, colours[3].hexString, colours[3].hexString))
//            GoXlr.shared.command(.SetButtonGroupColours(.SamplerButtons, colours[3].hexString, colours[3].hexString))
//            GoXlr.shared.command(.SetButtonColours(.Bleep, colours[3].hexString, colours[3].hexString))
//            GoXlr.shared.command(.SetButtonColours(.Cough, colours[3].hexString, colours[3].hexString))
//            GoXlr.shared.command(.SetButtonColours(.EffectMegaphone, colours[3].hexString, colours[3].hexString))
//            GoXlr.shared.command(.SetButtonColours(.EffectRobot, colours[3].hexString, colours[3].hexString))
//            GoXlr.shared.command(.SetButtonColours(.EffectHardTune, colours[3].hexString, colours[3].hexString))
//            GoXlr.shared.command(.SetButtonColours(.EffectFx, colours[3].hexString, colours[3].hexString))
//
//            GoXlr.shared.command(.SetEncoderColour(.Reverb, colours[3].hexString, colours[3].hexString, colours[5].hexString))
//            GoXlr.shared.command(.SetEncoderColour(.Pitch, colours[3].hexString, colours[3].hexString, colours[5].hexString))
//            GoXlr.shared.command(.SetEncoderColour(.Echo, colours[3].hexString, colours[3].hexString, colours[5].hexString))
//            GoXlr.shared.command(.SetEncoderColour(.Gender, colours[3].hexString, colours[3].hexString, colours[5].hexString))
//            GoXlr.shared.command(.SetSimpleColour(.Accent, colours[2].hexString))
//            GoXlr.shared.command(.SetSimpleColour(.Global, <#T##String#>))
            return [url : colours]
        } catch let error {
            print(error)
            return [:]
        }
    }
    var body: some View {
        VStack {
            let wallpaperColors = getWallpaper()
            AsyncImage(url: wallpaperColors.keys.first, content: {image in
                image
                    .resizable()
                    .scaledToFit()
            }, placeholder: {Spacer()})
            HStack {
                ForEach(wallpaperColors.values.first!, id:\.self) { colour in
                    VStack {
                        Color(nsColor: colour)
                            .frame(width: 40, height: 40)
                        Text(colour.hexString)
                            .textSelection(.enabled)
                    }
                }
            }
            Button("Set colors to faders") {
                GoXlr.shared.command(.SetAllFaderColours(wallpaperColors.values.first![0].hexString, wallpaperColors.values.first![1].hexString))
            }
        }.padding()
    }
}

extension NSColor {

    var hexString: String {
        let red = Int(round(self.redComponent * 0xFF))
        let green = Int(round(self.greenComponent * 0xFF))
        let blue = Int(round(self.blueComponent * 0xFF))
        let hexString = NSString(format: "%02X%02X%02X", red, green, blue)
        return hexString as String
    }

}
