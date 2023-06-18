//
//  View+ToggleOnGesture.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 18/06/2023.
//

import SwiftUI

struct ToggleOnGestureViewModifier: ViewModifier {
    @Binding var bool: Bool
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        bool = true
                    }
                    .onEnded { _ in
                        bool = false
                    }
            )
            .simultaneousGesture(
                LongPressGesture()
                    .onChanged { _ in
                        bool = true
                    }
                    .onEnded { _ in
                        bool = false
                    }
            )
            .simultaneousGesture(
                TapGesture()
                    .onEnded { _ in
                        bool = false
                    }
            )
    }
}

extension View {
    func toggleOnGesture(_ bool: Binding<Bool>) -> some View {
        self
            .modifier(ToggleOnGestureViewModifier(bool: bool))
        
    }
}
