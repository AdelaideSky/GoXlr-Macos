//
//  MenubarSettingsPage.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 25/04/2023.
//

import SwiftUI

struct MenubarSettingsPage: View {
    @ObservedObject var configuration = AppSettings.shared.menubar
    
    var body: some View {
        Form {
            Section("Enabled modules") {
                List {
                    ForEach(configuration.enabledModules, id:\.self) { module in
                        if let moduleData = configuration.availableModules[module] {
                            EnabledMenubarModuleRow(moduleData)
                        }
                    }.onMove { indices, newOffset in
                        configuration.enabledModules.move(fromOffsets: indices, toOffset: newOffset)
                    }
                    .onDelete() { index in
                        configuration.enabledModules.remove(at: index.first!)
                    }
                    .onInsert(of: [.text]) { offset, items in
                        _ = items.first!.loadObject(ofClass: String.self) { droppedString, _ in
                            if let dropped = droppedString {
                                if let module = MenubarModuleName(rawValue: dropped) {
                                    DispatchQueue.main.async {
                                        configuration.enabledModules.insert(module, at: offset)
                                    }
                                }
                            }
                        }
                    }
                    EnabledMenubarModuleRow(.init(.defaultControls, description: "The default app controls.", icon: .system("wrench.and.screwdriver"), baseColor: .gray, configurable: false))
                        .disabled(true)
                        .opacity(0.6)
                        .dropDestination(for: String.self) { text, location in
                            if let module = MenubarModuleName(rawValue: text.first!) {
                                configuration.enabledModules.append(module)
                                return true
                            } else { return false }
                        }
                }
            }
            Section("Available modules") {
                List {
                    ForEach(configuration.availableModules.sorted(by: {$0.key.rawValue > $1.key.rawValue}), id:\.key) { module in
                        if !configuration.enabledModules.contains(module.key) {
                            MenubarModuleRow(module.value)
                                .onDrag { NSItemProvider(object: module.key.rawValue as NSString) }
                        }
                    }
                }
            }
        }.formStyle(.grouped)
            .scrollContentBackground(.hidden)
    }
}

struct EnabledMenubarModuleRow: View {
    @ObservedObject var configuration = AppSettings.shared.menubar
    var module: MenubarModule

    init(_ module: MenubarModule) {
        self.module = module
    }
    
    @State var showSettingsSheet: Bool = false
    @Environment(\.isEnabled) var isEnabled
    
    var body: some View {
        HStack {
            Group {
                switch module.icon {
                case .system(let name):
                    Image(systemName: name)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .symbol(let name):
                    Image(name)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .asset(let name):
                    Image(name)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .padding(2.5)
            .foregroundColor(.white)
            .frame(width: 20, height: 20)
            .background {
                RoundedRectangle(
                    cornerRadius: 5,
                    style: .continuous
                )
                .fill(module.baseColor.gradient)
                .opacity(0.5)
            }
            VStack(alignment: .leading) {
                Text(module.name.rawValue)
                Text(module.description)
                    .font(.caption)
            }.padding(.leading, 2)
            
            Spacer()
            
            if module.configurable {
                Button(action: {
                    showSettingsSheet.toggle()
                }, label: {
                    Label("Configure", systemImage: "gear")
                        .labelStyle(.iconOnly)
                }).buttonStyle(.plain)
            } else if isEnabled {
                Button(action: {
                    configuration.enabledModules.removeAll(where: {$0 == module.name})
                }, label: {
                    Label("Disable", systemImage: "xmark")
                        .labelStyle(.iconOnly)
                }).buttonStyle(.plain)
                    .controlSize(.mini)
            }
            
        }.sheet(isPresented: $showSettingsSheet) {
            VStack {
                switch module.name {
                case .faders:
                    FadersMmodSettingsPage()
                case .routing:
                    RoutingMmodSettingsPage()
                default:
                    Text("Implementation needed")
                }
                Spacer(minLength: 0)
                Divider()
                HStack {
                    Button("Disable") {
                        showSettingsSheet.toggle()
                        configuration.enabledModules.removeAll(where: {$0 == module.name})
                    }.keyboardShortcut(.delete)
                    Spacer()
                    Button("Done") {
                        showSettingsSheet.toggle()
                    }.keyboardShortcut(.escape, modifiers: [])
                }.padding(.horizontal)
                    .padding(.bottom)
                    .padding(.top, 5)
            }.interactiveDismissDisabled(false)
                .frame(width: 400, height: 320)
        }
        .swipeActions(edge: .leading) {
            Button {
                showSettingsSheet.toggle()
            } label: {
                Label("Configure", systemImage: "gear")
            }
        }
    }
}
struct MenubarModuleRow: View {
    var module: MenubarModule

    init(_ module: MenubarModule) {
        self.module = module
    }
    
    @State var showSettingsSheet: Bool = false

    var body: some View {
        HStack {
            Group {
                switch module.icon {
                case .system(let name):
                    Image(systemName: name)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .symbol(let name):
                    Image(name)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .asset(let name):
                    Image(name)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .padding(2.5)
            .foregroundColor(.white)
            .frame(width: 20, height: 20)
            .background {
                RoundedRectangle(
                    cornerRadius: 5,
                    style: .continuous
                )
                .fill(module.baseColor.gradient)
                .opacity(0.4)
            }
            VStack(alignment: .leading) {
                Text(module.name.rawValue)
                Text(module.description)
                    .font(.caption)
            }.padding(.leading, 2)
            
            Spacer()
            
        }
    }
}
