//
//  VolumeSliderElement.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 18/04/2023.
//

import Foundation
import SwiftUI
import GoXlrKit

struct HVolumeSlider: View {

    @Binding var value: Float // a number from 1 to 100
    let image: String
//    let channel: ChannelName
    var sliderWidth: Float = 252.5
    var sliderHeight: Float = 22
    
    @Environment(\.colorScheme) var colorScheme
    
    let myGray: Color = Color(red: 0.5, green: 0.5, blue: 0.5)
    let lightGray: Color = Color(red: 0.8, green: 0.8, blue: 0.8)

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(colorScheme == .dark ? self.myGray.opacity(0.5) : self.lightGray.opacity(0.5))
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.accentColor)
                        .frame(width: geometry.size.width * CGFloat(self.value / 255))
                    Circle()
                        .foregroundColor(.white)
                        .shadow(radius: colorScheme == .dark ? 5 : 1)
                        .frame(width: CGFloat(self.sliderHeight), height: CGFloat(self.sliderHeight - 0.2), alignment: .trailing)
                        .offset(x: self.value == 255 ? CGFloat(self.value/2.02 - self.sliderHeight/2) : CGFloat(self.value/2.02), y: 0)
                }
                
                // Delete this code if you don't want an image in your slider
                // This is set up to support SF Symbols by default, but of course you can simply remove the systemName parameter to provide whatever image you like
                
                Image(systemName: self.image)
                    .frame(width: CGFloat(self.sliderHeight - 20),height: CGFloat(self.sliderHeight - 20))
                    .foregroundColor(self.myGray.opacity(1))
                    .offset(x: 10, y: 0)
            }
            .frame(width: CGFloat(self.sliderWidth), height: CGFloat(self.sliderHeight))
        .cornerRadius(20)
            .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(self.myGray, lineWidth: 0.5)
                )
            .gesture(DragGesture(minimumDistance: 0.1)
                .onChanged({ value in
                    GoXlr.shared.socket.holdUpdates = true
                    let newValue = min(max(0, Float(value.location.x / geometry.size.width * 255)), 255)
                    
                    if Int(newValue) != Int(self.value) {
                        if newValue == 255 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .drawCompleted)}
                        else if newValue == 0 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .drawCompleted)}
                        
//                        GoXlr.shared.command(.SetVolume(channel, Int(min(max(0, Float(value.location.x / geometry.size.width * 255)), 255))))
                        self.value = newValue
                    }
                
                })
                    .onEnded() {_ in
                        GoXlr.shared.socket.holdUpdates = false
                    })
                

        }.frame(width: CGFloat(sliderWidth), height: CGFloat(sliderHeight))
    }
    
}

struct VVolumeSlider: View {

    @Binding var value: Float
    let image: String
    
    var sliderWidth: Float = 25
    var sliderHeight: Float = 200
    @Environment(\.colorScheme) var colorScheme
    
    let myGray: Color = Color(red: 0.5, green: 0.5, blue: 0.5)
    let lightGray: Color = Color(red: 0.8, green: 0.8, blue: 0.8)

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(colorScheme == .dark ? self.myGray.opacity(0.5) : self.lightGray.opacity(0.5))
                
                VStack {
                    Spacer(minLength: 0)
                    RoundedRectangle(cornerRadius: 50)
                        .foregroundColor(.accentColor)
                        .frame(height: max(0, (CGFloat(sliderHeight) - CGFloat(self.sliderWidth)) * CGFloat(self.value / 255)) + CGFloat(self.sliderWidth))
                }

                VStack {
                    Spacer(minLength: 0)
                    Circle()
                        .foregroundColor(.white)
                        .shadow(radius: colorScheme == .dark ? 5 : 1)
                        .frame(width: CGFloat(self.sliderWidth), height: CGFloat(self.sliderWidth))
                        .offset(y: -max(0, (geometry.size.height - geometry.size.width) * CGFloat(self.value / 255)))
                    
                }
                
                VStack {
                    Spacer(minLength: 0)
                    Image(systemName: self.image)
                        .frame(width: CGFloat(self.sliderWidth - 20),height: CGFloat(self.sliderWidth - 20))
                        .foregroundColor(self.myGray.opacity(1))
                        .offset(x: 10, y: -10)
                }
            }
            .frame(width: CGFloat(self.sliderWidth), height: CGFloat(self.sliderHeight))
            .cornerRadius(20)
            .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(self.myGray, lineWidth: 0.5)
                )
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged({ value in
                    GoXlr.shared.socket.holdUpdates = true
                    let newY = max(min(value.location.y, geometry.size.height - CGFloat(self.sliderWidth) / 2), CGFloat(self.sliderWidth) / 2)
                    let newValue = min(max(0, Float((255 - (newY - CGFloat(self.sliderWidth) / 2) / (geometry.size.height - CGFloat(self.sliderWidth)) * 255))), 255)

                    if Int(newValue) != Int(self.value) {
                        if newValue == 255 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .drawCompleted)}
                        else if newValue == 0 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .drawCompleted)}
                        
                        self.value = newValue
                    }
                
                })
                    .onEnded() {_ in
                        GoXlr.shared.socket.holdUpdates = false
                    })
                

        }.frame(width: CGFloat(sliderWidth), height: CGFloat(sliderHeight))
    }
    
}
