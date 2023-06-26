//
//  About View.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 19/06/2023.
//

import SwiftUI
import SkyKit_Design

struct AboutView: View {
    var body: some View {
        VStack {
            NavigationStack {
                VStack {
                    Image(.appIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                    Text("About GoXlr App")
                        .font(.title2)
                        .bold()
                    Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
                    HStack {
                        Group {
                            Link(destination: URL(string: "https://github.com/AdelaideSky/GoXlr-Macos")!, label: {
                                VStack {
                                    Image(systemName: "books.vertical")
                                        .font(.title)
                                        .padding(.bottom, 1)
                                    Text("GitHub")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }).buttonStyle(.gentleFilling)
                            Link(destination: URL(string: "https://github.com/AdelaideSky/GoXlrKit")!, label: {
                                VStack {
                                    Image(systemName: "square.stack.3d.up")
                                        .font(.title)
                                        .padding(.bottom, 1)
                                    Text("GoXLRKit")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }).buttonStyle(.gentleFilling)
                            Link(destination: URL(string: "https://discord.gg/cyavp8F2WW")!, label: {
                                VStack {
                                    Image(systemName: "bubble.left.and.bubble.right")
                                        .font(.title)
                                        .padding(.bottom, 1)
                                    Text("Discord")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }).buttonStyle(.gentleFilling)
                            Link(destination: URL(string: "https://github.com/sponsors/AdelaideSky")!, label: {
                                VStack {
                                    ZStack {
                                        Image(systemName: "heart")
                                            .font(.title)
                                            .padding(.bottom, 1)
                                    }
                                    Text("Support")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }).buttonStyle(GentleFillingButtonStyle(multicolorIconOnClick: true))
                        }.padding(1)
                    }.frame(height: 60)
                        .padding(.horizontal, 20)
                        .padding(.top, 5)
                }
                Form {
                    Section() {
                        NavigationLink("License") {
                            LicenseView(URL(string: "https://raw.githubusercontent.com/AdelaideSky/GoXlr-Macos/main/LICENSE")!)
                                
                        }
                    }
                    Section("Made with 🍵 by") {
                        HStack {
                            Spacer()
                            VStack {
                                AsyncImage(url: URL(string: "https://cdn.discordapp.com/avatars/323812769101250561/0f334ea04aade386a97eb99cc3f11275.webp?size=160")!,
                                           content: { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 45)
                                        .clipShape(Circle())
                                        .background {
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(Circle())
                                                .blur(radius: 10)
                                        }
                                }, placeholder: {
                                    ProgressView()
                                        .scaleEffect(0.5)
                                })
                                Text("Adélaïde Sky")
                                    .font(.headline)
                            }
                            Spacer()
                        }
                        HStack {
                            Text("Discord")
                            Spacer()
                            Text("[@adelaidesky](https://discord.com/users/323812769101250561)")
                        }
                        HStack {
                            Text("GitHub")
                            Spacer()
                            Text("[AdelaideSky](https://github.com/AdelaideSky)")
                        }
                        HStack {
                            Text("Instagram")
                            Spacer()
                            Text("[adesky__](https://www.instagram.com/adesky__/)")
                        }
                    }
                }.formStyle(.grouped)
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                    .scrollDisabled(true)
                    .clipped()
            }
            
        }.frame(minWidth: 360, minHeight: 510)
            .background {
                ZStack {
                    SKEffectsView(.hudWindow, blendingMode: .behindWindow)
                    SKNoiseTexture()
                        .opacity(0.05)
                }.padding(-100)
            }
            
    }
}
