//
//  AboutUtilityView.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 22/06/2023.
//

import SwiftUI
import SkyKit_Design
import GoXlrKit

struct AboutUtilityView: View {
    var body: some View {
        VStack {
            NavigationStack {
                VStack {
                    AsyncImage(url: URL(string: "https://github.com/GoXLR-on-Linux/.github/blob/main/img/GoXLR-Linux.png?raw=true"), content: { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                    }, placeholder: {
                        ProgressView()
                            .scaleEffect(0.5)
                    })
                    Text("About GoXLR-Utility")
                        .font(.title2)
                        .bold()
                    Text(GoXlr.shared.status?.data.status.config.daemonVersion ?? "unknown")
                    HStack {
                        Group {
                            Link(destination: URL(string: "https://github.com/GoXLR-on-Linux/goxlr-utility")!, label: {
                                VStack {
                                    Image(systemName: "books.vertical")
                                        .font(.title)
                                        .padding(.bottom, 1)
                                    Text("GitHub")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }).buttonStyle(.gentleFilling)
                            Link(destination: URL(string: "https://discord.gg/Wbp3UxkX2j")!, label: {
                                VStack {
                                    Image(systemName: "bubble.left.and.bubble.right")
                                        .font(.title)
                                        .padding(.bottom, 1)
                                    Text("Discord")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }).buttonStyle(.gentleFilling)
                            Link(destination: URL(string: "https://github.com/sponsors/FrostyCoolSlug")!, label: {
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
                            LicenseView(URL(string: "https://raw.githubusercontent.com/GoXLR-on-Linux/goxlr-utility/main/LICENSE")!)                                
                        }
                    }
                    Section("Made with ☕️ by") {
                        HStack {
                            Spacer()
                            VStack {
                                AsyncImage(url: URL(string: "https://avatars.githubusercontent.com/u/574943?v=4")!,
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
                                Text("FrostyCoolSlug")
                                    .font(.headline)
                            }
                            Spacer()
                        }
                        HStack {
                            Text("Discord")
                            Spacer()
                            Text("[@frostycoolslug](https://discord.com/users/128216920200577026)")
                        }
                        HStack {
                            Text("GitHub")
                            Spacer()
                            Text("[FrostyCoolSlug](https://github.com/FrostyCoolSlug)")
                        }
                    }
                }.formStyle(.grouped)
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                    .scrollDisabled(true)
                    .clipped()
            }
            
        }.frame(minWidth: 360, minHeight: 480)
            .background {
                ZStack {
                    SKEffectsView(.hudWindow, blendingMode: .behindWindow)
                    SKNoiseTexture()
                        .opacity(0.05)
                }.padding(-100)
            }
            
    }
}
