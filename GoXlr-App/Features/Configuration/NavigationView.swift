//
//  NavigationView.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 17/04/2023.
//

import Foundation
import SwiftUI
import GoXlrKit

struct NavigationView: View {
    @ObservedObject var goxlr = GoXlr.shared
    var body: some View {
        NavigationSplitView(sidebar: {
            List {
                ForEach(ConfigurationPages().appropriateTabs(goxlr)) { tabGroup in
                    if tabGroup.name.isEmpty {
                        ForEach(tabGroup.tabs) { tab in
                            NavigationLink(value: tab) {
                                Label(tab.name, systemImage: tab.icon)
                            }
                        }
                    } else {
                        Section(tabGroup.name) {
                            ForEach(tabGroup.tabs) { tab in
                                NavigationLink(value: tab) {
                                    Label(tab.name, systemImage: tab.icon)
                                }
                            }
                        }
                    }
                }
            }.listStyle(.sidebar)
                .background() {
                    EffectsView(material: .sidebar, blendingMode: .behindWindow).ignoresSafeArea()
                }
                .navigationDestination(for: Tab.self) { tab in
                    Group {
                        switch tab.id {
                        case .mic:
                            MicView()
                        case .mixer:
                            MixerView()
                        case .effects:
                            FXView()
                        default:
                            Text("Not yet implemented !")
                                .font(.headline)
                                .padding()
                            Link(destination: URL(string: "http://localhost:14564/")!, label: {
                                VStack {
                                    Image(systemName: "gear")
                                        .font(.title)
                                        .padding(.bottom, 3)
                                    Text("Go on the GoXLr Utility's webUI to configure this tab")
                                        .font(.callout)
                                }
                                    .foregroundColor(.white)
                                    .padding()
                                    .background {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill()
                                            .foregroundColor(.accentColor)
                                            .opacity(0.6)
                                    }
                            }).frame(width: 250)
                        }
                    }.clipped()
                        .navigationTitle(tab.name)
                }
        }, detail: {
            Group {
                
            }.clipped()
        })
    }
}
