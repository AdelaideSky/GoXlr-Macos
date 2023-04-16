//
//  ContentView.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 27/12/2022.
//

import SwiftUI
import GoXlrKit

struct ContentView: View {
    
    @ObservedObject var goxlr = GoXlr.shared
    
    var body: some View {
        VStack {
            if goxlr.status != nil {
                Text("Connected to the Daemon with GoXlr \(goxlr.device)")
                    .padding()
                Text("Goxlr's System volume: \(goxlr.mixer?.levels.volumes.system ?? 0)")
                Button("Set System volume to 100%") {
                    guard goxlr.device != "" else { return } // check if a GoXlr is connected
                    
                    goxlr.mixer!.levels.volumes.system = 255 //Set System volume to maximum. Volumes are a Float going from 0 to 255 (The daemon only uses Int values but GoXlrKit provides Float values to allow directly binding to sliders)
                    //As you can see, you don't need to manually send the commands to the Daemon: the module does it by itself.
                }.disabled(goxlr.status == nil)
                
            } else {
                ProgressView()
            }
        }.onAppear() {
            //goxlr.startObserving() // Start the Daemon and connect to its WebSocket
            //If you don't need to connect to the websocket, you can do goxlr.daemon.start(args: [DaemonArguments])
            //If you only need to connect to the websocket, do goxlr.socket.connect()
            //Make sure the utility isn't already launched, else the app will crash
        }
        .padding()
    }
}

extension Binding {
    func unwrap<Wrapped>() -> Binding<Wrapped>? where Optional<Wrapped> == Value {
        guard let value = self.wrappedValue else { return nil }
        return Binding<Wrapped>(
            get: {
                return value
            },
            set: { value in
                self.wrappedValue = value
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct VolumeSlider: View {

    
    @Binding var percentage: Float // a number from 1 to 100
    let image: String
    let channel: ChannelName
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
                        .frame(width: geometry.size.width * CGFloat(self.percentage / 255))
                    Circle()
                        .foregroundColor(.white)
                        .shadow(radius: colorScheme == .dark ? 5 : 1)
                        .frame(width: CGFloat(self.sliderHeight), height: CGFloat(self.sliderHeight - 0.2), alignment: .trailing)
                        .offset(x: self.percentage == 255 ? CGFloat(self.percentage/2.02 - self.sliderHeight/2) : CGFloat(self.percentage/2.02), y: 0)
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
                        self.percentage = min(max(0, Float(value.location.x / geometry.size.width * 255)), 255)
                    if min(max(0, Float(value.location.x / geometry.size.width * 255)), 255) == 255 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .drawCompleted)}
                    else if min(max(0, Float(value.location.x / geometry.size.width * 255)), 255) == 0 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .drawCompleted)}
                    GoXlr.shared.command(.SetVolume(channel, Int(min(max(0, Float(value.location.x / geometry.size.width * 255)), 255))))
                })
                    .onEnded() {_ in 
                        GoXlr.shared.socket.holdUpdates = false
                    })
                

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
                        DragGesture(minimumDistance: 0.1)
                            .onEnded({ _ in
                                self.validDrag = false
                                self.onEditingChanged(false)
                            })
                            .onChanged(self.handleDragged(in: geometry))
                )
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
                    GoXlr.shared.command(.SetVolume(.LineOut, Int(clampedValue)))
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
