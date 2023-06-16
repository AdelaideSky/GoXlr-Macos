//
//  SamplerView.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 28/05/2023.
//

import SwiftUI
import GoXlrKit

struct SamplerView: View {
    @ObservedObject var router = GoXlr.shared.mixer!.router
    
    var body: some View {
        NavigationStack {
            Form {
                ForEach(["Bank A", "Bank B", "Bank C"], id:\.self) { bankTitle in
                    Section(bankTitle) {
                        HStack {
                            GroupBox {
                                NavigationLink("Top Left", value: "Top Left")
                                    .padding()
                            }
                            GroupBox {
                                NavigationLink("Top Right", value: "Top Right")
                                    .padding()
                            }
                        }
                        HStack {
                            GroupBox {
                                NavigationLink("Bottom Left", value: "Bottom Left")
                                    .padding()
                            }
                            GroupBox {
                                NavigationLink("Bottom Right", value: "Bottom Right")
                                    .padding()
                            }
                        }
                        
                    }
                }
                
            }.formStyle(.grouped)
                .scrollContentBackground(.hidden)
                .navigationDestination(for: String.self) {Text($0)}
        }
    }
}
