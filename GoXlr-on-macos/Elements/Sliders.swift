//
//  BigSurSlider.swift
//
//  Created by Aditya Rudrapatna on 18/08/2020.
//  Copyright © 2020 Aditya Rudrapatna. All rights reserved.
//

import SwiftUI

struct BigSurSlider: View {

    @Binding var percentage: Float // a number from 1 to 100
    var sliderWidth: Float = 200
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
                        .frame(width: geometry.size.width * CGFloat(self.percentage / 100))
                    Circle()
                        .foregroundColor(.white)
                        .shadow(radius: colorScheme == .dark ? 5 : 1)
                        .frame(width: CGFloat(self.sliderHeight), height: CGFloat(self.sliderHeight), alignment: .trailing)
                        .offset(x: self.percentage == 100 ? CGFloat(self.percentage - self.sliderHeight/2) : CGFloat(self.percentage), y: 0)
                }
                
                // Delete this code if you don't want an image in your slider
                // This is set up to support SF Symbols by default, but of course you can simply remove the systemName parameter to provide whatever image you like
                
                
            }
            .frame(width: CGFloat(self.sliderWidth), height: CGFloat(self.sliderHeight))
        .cornerRadius(20)
            .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(colorScheme == .dark ? self.myGray : self.lightGray, lineWidth: 0.5)
                )
            .gesture(DragGesture(minimumDistance: 0.1)
                .onChanged({ value in
                    self.percentage = min(max(0, Float(value.location.x / geometry.size.width * 100)), 100)
                }))
            .onChange(of: self.percentage) { newValue in
                if newValue == 100 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .drawCompleted)}
                else if newValue == 0 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .drawCompleted)}
            }
            .animation(.default)
                

        }.frame(width: CGFloat(sliderWidth), height: CGFloat(sliderHeight))
    }
    
}


struct bigVSlider<V: BinaryFloatingPoint>: View {
    var value: Binding<V>
    var range: ClosedRange<V> = 0...1
    var step: V.Stride? = nil
    var onEditingChanged: (Bool) -> Void = { _ in }
    let darkGray: Color = Color(red: 0.3, green: 0.3, blue: 0.3)
    let lightGray: Color = Color(red: 0.8, green: 0.8, blue: 0.8)
    var displayString: String
    var textSize: Int = 11
    var yVal: Int = -4
    @Environment(\.colorScheme) var colorScheme

    private let drawRadius: CGFloat = 12.5
    private let dragRadius: CGFloat = 25
    private let lineWidth: CGFloat = 25
    

    @State private var validDrag = false

    init(value: Binding<V>, in range: ClosedRange<V> = 0...1, step: V.Stride? = nil, display: String, textsize: Int, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.value = value
        self.displayString = display
        self.textSize = textsize
        
        if textsize == 9 {
            yVal = -7
        }

        if let step = step {
            self.step = step
            var newUpperbound = range.lowerBound
            while newUpperbound.advanced(by: step) <= range.upperBound{
                newUpperbound = newUpperbound.advanced(by: step)
            }
            self.range = ClosedRange(uncheckedBounds: (range.lowerBound, newUpperbound))
        } else {
            self.range = range
        }

        self.onEditingChanged = onEditingChanged
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                ZStack(alignment: .bottom) {
                    // Gray section of line

                    Rectangle()
                        .foregroundColor(colorScheme == .dark ? self.darkGray.opacity(0.5) : self.lightGray.opacity(0.5))
                        .cornerRadius(20)
                        .frame(width: self.lineWidth+2)
                    
                    // Blue section of line
                    Rectangle()
                        .foregroundColor(.accentColor)
                        .frame(height: geometry.size.height - self.getPoint(in: geometry).y+11)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .frame(width: self.lineWidth)
                }
                

                // Handle
                Circle()
                    .frame(width: 2 * self.drawRadius, height: 2 * self.drawRadius)
                    .position(self.getPoint(in: geometry))
                    .foregroundColor(.white)
                    .shadow(radius: colorScheme == .dark ? 5 : 1)
                
                Text(displayString)
                    .frame(width: .none, height: self.drawRadius, alignment: .bottom)
                    .foregroundColor(colorScheme == .dark ? self.darkGray.opacity(2) : self.lightGray.opacity(2))
                    .font(.system(size: CGFloat(textSize)))
                    .offset(x: 0, y: CGFloat(yVal))

                // Catches drag gesture
                Rectangle()
                    .frame(minWidth: CGFloat(self.dragRadius))
                    .foregroundColor(Color.red.opacity(0.001))
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onEnded({ _ in
                                self.validDrag = false
                                self.onEditingChanged(false)
                            })
                            .onChanged(self.handleDragged(in: geometry))
                )
                    .onChange(of: self.value.wrappedValue) { newValue in
                        if newValue == range.upperBound {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .drawCompleted)}
                        else if newValue == range.lowerBound {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .drawCompleted)}
                    }
            }
        }
    }
}

extension bigVSlider {
    private func getPoint(in geometry: GeometryProxy) -> CGPoint {
        let x = geometry.size.width / 2
        let location = value.wrappedValue - range.lowerBound
        let scale = V(2 * drawRadius - geometry.size.height) / (range.upperBound - range.lowerBound)
        let y = CGFloat(location * scale) + geometry.size.height - drawRadius
        return CGPoint(x: x, y: y)
    }

    private func handleDragged(in geometry: GeometryProxy) -> (DragGesture.Value) -> Void {
        return { drag in
            if drag.startLocation.distance(to: self.getPoint(in: geometry)) < self.dragRadius && !self.validDrag {
                self.validDrag = true
                self.onEditingChanged(true)
            }

            if self.validDrag {
                let location = drag.location.y - geometry.size.height + self.drawRadius
                let scale = CGFloat(self.range.upperBound - self.range.lowerBound) / (2 * self.drawRadius - geometry.size.height)
                let newValue = V(location * scale) + self.range.lowerBound
                let clampedValue = max(min(newValue, self.range.upperBound), self.range.lowerBound)

                if self.step != nil {
                    let step = V.zero.advanced(by: self.step!)
                    self.value.wrappedValue = round((clampedValue - self.range.lowerBound) / step) * step + self.range.lowerBound
                } else {
                    self.value.wrappedValue = clampedValue
                }
            }
        }
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}



struct micMonitor<V: BinaryFloatingPoint>: View {
    var value: Binding<V>
    var range: ClosedRange<V> = 0...1
    var step: V.Stride? = nil
    var onEditingChanged: (Bool) -> Void = { _ in }
    let darkGray: Color = Color(red: 0.3, green: 0.3, blue: 0.3)
    let lightGray: Color = Color(red: 0.8, green: 0.8, blue: 0.8)
    var displayString: String
    var textSize: Int = 11
    var yVal: Int = -4
    @Environment(\.colorScheme) var colorScheme

    private let drawRadius: CGFloat = 12.5
    private let dragRadius: CGFloat = 25
    private let lineWidth: CGFloat = 10
    

    @State private var validDrag = false

    init(value: Binding<V>, in range: ClosedRange<V> = 0...1, step: V.Stride? = nil, display: String, textsize: Int, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.value = value
        self.displayString = display
        self.textSize = textsize
        
        if textsize == 9 {
            yVal = -7
        }

        if let step = step {
            self.step = step
            var newUpperbound = range.lowerBound
            while newUpperbound.advanced(by: step) <= range.upperBound{
                newUpperbound = newUpperbound.advanced(by: step)
            }
            self.range = ClosedRange(uncheckedBounds: (range.lowerBound, newUpperbound))
        } else {
            self.range = range
        }

        self.onEditingChanged = onEditingChanged
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                
                ZStack(alignment: .bottom) {
                    // Gray section of line
//                    VStack {
                        
//                        Rectangle().foregroundColor(.gray).frame(width: 30, height: 1)
//                            .padding(.bottom, 40)
                        
//                        Rectangle().foregroundColor(.gray).frame(width: 30, height: 1)
//                            .padding(.bottom, 80)
                        
//                    }.padding(.left, 15)

                    Rectangle()
                        .foregroundColor(colorScheme == .dark ? self.darkGray.opacity(0.5) : self.lightGray.opacity(0.5))
                        .cornerRadius(20)
                        .frame(width: self.lineWidth+2)
                    
                    // Blue section of line
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [.orange,.yellow, .green, .red]), startPoint: .bottom, endPoint: .top))
                        .frame(width: self.lineWidth+2)
                        .cornerRadius(20)
                        .mask(alignment: .bottom) {
                            Rectangle()
                                .frame(height: geometry.size.height - self.getPoint(in: geometry).y-12)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .frame(width: self.lineWidth)
                        }
                }
            }
        }
    }
}

extension micMonitor {
    private func getPoint(in geometry: GeometryProxy) -> CGPoint {
        let x = geometry.size.width / 2
        let location = value.wrappedValue - range.lowerBound
        let scale = V(2 * drawRadius - geometry.size.height) / (range.upperBound - range.lowerBound)
        let y = CGFloat(location * scale) + geometry.size.height - drawRadius
        return CGPoint(x: x, y: y)
    }
}

struct lightBSLIDER<V: BinaryFloatingPoint>: View {
    var value: Binding<V>
    var range: ClosedRange<V> = 0...1
    var step: V.Stride? = nil
    var onEditingChanged: (Bool) -> Void = { _ in }
    let darkGray: Color = Color(red: 0.3, green: 0.3, blue: 0.3)
    let lightGray: Color = Color(red: 0.8, green: 0.8, blue: 0.8)
    var displayString: String
    var textSize: Int = 11
    var yVal: Int = -4
    @Environment(\.colorScheme) var colorScheme

    private let drawRadius: CGFloat = 11
    private let dragRadius: CGFloat = 21
    private let lineWidth: CGFloat = 21
    

    @State private var validDrag = false

    init(value: Binding<V>, in range: ClosedRange<V> = 0...1, step: V.Stride? = nil, display: String, textsize: Int, onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
        self.value = value
        self.displayString = display
        self.textSize = textsize
        
        if textsize == 9 {
            yVal = -7
        }

        if let step = step {
            self.step = step
            var newUpperbound = range.lowerBound
            while newUpperbound.advanced(by: step) <= range.upperBound{
                newUpperbound = newUpperbound.advanced(by: step)
            }
            self.range = ClosedRange(uncheckedBounds: (range.lowerBound, newUpperbound))
        } else {
            self.range = range
        }

        self.onEditingChanged = onEditingChanged
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                ZStack(alignment: .bottom) {
                    // Gray section of line

                    Rectangle()
                        .foregroundColor(colorScheme == .dark ? self.darkGray.opacity(0.5) : self.lightGray.opacity(0.5))
                        .cornerRadius(20)
                        .frame(width: self.lineWidth+2)
                    
                    // Blue section of line
                    Rectangle()
                        .foregroundColor(.accentColor)
                        .frame(height: geometry.size.height - self.getPoint(in: geometry).y+11)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .frame(width: self.lineWidth)
                }
                

                // Handle
                Circle()
                    .frame(width: 2 * self.drawRadius, height: 2 * self.drawRadius)
                    .position(self.getPoint(in: geometry))
                    .foregroundColor(.white)
                    .shadow(radius: colorScheme == .dark ? 5 : 1)
                if displayString != "" {
                    Image(systemName: displayString)
                        .frame(width: .none, height: self.drawRadius, alignment: .bottom)
                        .foregroundColor(colorScheme == .dark ? self.darkGray.opacity(2) : self.lightGray.opacity(2))
                        .font(.system(size: CGFloat(textSize)))
                        .offset(x: 0, y: CGFloat(yVal))
                }

                // Catches drag gesture
                Rectangle()
                    .frame(minWidth: CGFloat(self.dragRadius))
                    .foregroundColor(Color.red.opacity(0.001))
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onEnded({ _ in
                                self.validDrag = false
                                self.onEditingChanged(false)
                            })
                            .onChanged(self.handleDragged(in: geometry))
                )
            }.animation(.default, value: 10)
        }
    }
}

extension lightBSLIDER {
    private func getPoint(in geometry: GeometryProxy) -> CGPoint {
        let x = geometry.size.width / 2
        let location = value.wrappedValue - range.lowerBound
        let scale = V(2 * drawRadius - geometry.size.height) / (range.upperBound - range.lowerBound)
        let y = CGFloat(location * scale) + geometry.size.height - drawRadius
        return CGPoint(x: x, y: y)
    }

    private func handleDragged(in geometry: GeometryProxy) -> (DragGesture.Value) -> Void {
        return { drag in
            if drag.startLocation.distance(to: self.getPoint(in: geometry)) < self.dragRadius && !self.validDrag {
                self.validDrag = true
                self.onEditingChanged(true)
            }

            if self.validDrag {
                let location = drag.location.y - geometry.size.height + self.drawRadius
                let scale = CGFloat(self.range.upperBound - self.range.lowerBound) / (2 * self.drawRadius - geometry.size.height)
                let newValue = V(location * scale) + self.range.lowerBound
                let clampedValue = max(min(newValue, self.range.upperBound), self.range.lowerBound)

                if self.step != nil {
                    let step = V.zero.advanced(by: self.step!)
                    self.value.wrappedValue = round((clampedValue - self.range.lowerBound) / step) * step + self.range.lowerBound
                } else {
                    self.value.wrappedValue = clampedValue
                }
            }
        }
    }
}

struct makupGainSlider: View {

    @Binding var percentage: Float // a number from 1 to 100
    var sliderWidth: Float = 200
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
                        .frame(width: geometry.size.width * CGFloat(self.percentage / 24))
                    Circle()
                        .foregroundColor(.white)
                        .shadow(radius: colorScheme == .dark ? 5 : 1)
                        .frame(width: CGFloat(self.sliderHeight), height: CGFloat(self.sliderHeight), alignment: .trailing)
                        .offset(x: self.percentage == 24 ? CGFloat(self.percentage / 24 * 100 - self.sliderHeight/2) : CGFloat(self.percentage / 24 * 100), y: 0)
                }
                
                // Delete this code if you don't want an image in your slider
                // This is set up to support SF Symbols by default, but of course you can simply remove the systemName parameter to provide whatever image you like
                
                
            }
            .frame(width: CGFloat(self.sliderWidth), height: CGFloat(self.sliderHeight))
        .cornerRadius(20)
            .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(colorScheme == .dark ? self.myGray : self.lightGray, lineWidth: 0.5)
                )
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged({ value in
                    self.percentage = min(max(0, Float(value.location.x / geometry.size.width * 24)), 24)
                }))
            .animation(.default)
                

        }.frame(width: CGFloat(sliderWidth), height: CGFloat(sliderHeight))
    }
    
}




struct TouchGestureViewModifier: ViewModifier {
    let touchBegan: () -> Void
    let touchEnd: (Bool) -> Void

    @State private var hasBegun = false
    @State private var hasEnded = false

    private func isTooFar(_ translation: CGSize) -> Bool {
        let distance = sqrt(pow(translation.width, 2) + pow(translation.height, 2))
        return distance >= 20.0
    }

    func body(content: Content) -> some View {
        content.gesture(DragGesture(minimumDistance: 0)
                .onChanged { event in
                    guard !self.hasEnded else { return }

                    if self.hasBegun == false {
                        self.hasBegun = true
                        self.touchBegan()
                    } else if self.isTooFar(event.translation) {
                        self.hasEnded = true
                        self.touchEnd(false)
                    }
                }
                .onEnded { event in
                    if !self.hasEnded {
                        let success = !self.isTooFar(event.translation)
                        self.touchEnd(success)
                    }
                    self.hasBegun = false
                    self.hasEnded = false
                })
    }
}

extension View {
    func onTouchGesture(touchBegan: @escaping () -> Void,
                      touchEnd: @escaping (Bool) -> Void) -> some View {
        modifier(TouchGestureViewModifier(touchBegan: touchBegan, touchEnd: touchEnd))
    }
}

struct MenubarSlider: View {

    
    @Binding var percentage: Float // a number from 1 to 100
    let image:String
    var sliderWidth: Float = 230
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
                        .frame(width: 15)
                        .offset(x: -5)
                    Rectangle()
                        .foregroundColor(.accentColor)
                        .frame(width: geometry.size.width * CGFloat(self.percentage / 255))
                    Circle()
                        .foregroundColor(.white)
                        .shadow(radius: colorScheme == .dark ? 5 : 1)
                        .frame(width: CGFloat(self.sliderHeight), height: CGFloat(self.sliderHeight - 0.2), alignment: .trailing)
                        .offset(x: self.percentage == 255 ? CGFloat(self.percentage/2.2 - self.sliderHeight/2) : CGFloat(self.percentage/2.2), y: 0)
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
                    self.percentage = min(max(0, Float(value.location.x / geometry.size.width * 255)), 255)
                }))
            .onChange(of: self.percentage) { newValue in
                if newValue == 255 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .drawCompleted)}
                else if newValue == 0 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .drawCompleted)}
            }
            .animation(.default)
                

        }.frame(width: CGFloat(sliderWidth), height: CGFloat(sliderHeight))
    }
    
}
