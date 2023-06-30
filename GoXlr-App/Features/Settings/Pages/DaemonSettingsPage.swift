//
//  DaemonSettingsPage.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 18/06/2023.
//

import SwiftUI
import GoXlrKit
import SkyKit_Design

struct DaemonSettingsPage: View {
    @ObservedObject var status = GoXlr.shared.status!.data.status
    @ObservedObject var daemon = GoXlr.shared.daemon
    @ObservedObject var appSettings = AppSettings.shared
    
    var body: some View {
        NavigationStack {
            Form {
                Button(action: {
                    AppDelegate().showAboutPanel(.utility)
                }, label: {
                    ZStack {
                        Rectangle()
                            .opacity(0.0001)
                        HStack {
                            Text("About")
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .opacity(0.8)
                        }
                    }
                }).buttonStyle(.plain)
                
                Section("Configuration") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Allow UI network access")
                                .font(.callout)
                            Text("Requires daemon restart")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Toggle("", isOn: $status.config.allowNetworkAccess)
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Log Level")
                                .font(.callout)
                            Text("Requires daemon restart")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Picker("Log Level", selection: $status.config.logLevel) {
                            ForEach(Daemon.logLevels.allCases, id:\.rawValue) { logLevel in
                                Text(logLevel.rawValue).tag(logLevel)
                            }
                        }.labelsHidden()
                            .fixedSize()
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Show Tray Icon")
                                .font(.callout)
                            Text("Requires daemon restart")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Toggle("", isOn: $status.config.showTrayIcon)
                    }
                }
                Section("HTTP Settings") {
                    Toggle("Enabled", isOn: $status.config.httpSettings.enabled)
                    TextField("Bind Address", text: $status.config.httpSettings.bindAddress)
                    TextField("Port", value: $status.config.httpSettings.port, formatter: NumberFormatter())
                    Toggle("Cors enabled", isOn: $status.config.httpSettings.corsEnabled)
                }
                .disabled(true)

                Section("Advanced") {
                    NavigationLink("Logs", destination: {
                        LogsView(URL(filePath: status.paths.logsDirectory+"/goxlr-daemon.log"))
                            .navigationTitle("Daemon logs")
                    })
                    DisclosureGroup("Dangerous zone") {
                        HStack {
                            Text("Daemon")
                            Spacer()
                            Button(daemon.daemonStatus == .running ? "Stop Daemon" : "Start Daemon") {
                                if daemon.daemonStatus == .running {
                                    GoXlr.shared.stopObserving()
                                    daemon.stop()
                                } else {
                                    GoXlr.shared.startObserving()
                                }
                            }.buttonStyle(.gentle)
                        }
                    }
                    
                }
                
            }.formStyle(.grouped)
                .scrollContentBackground(.hidden)
        }
    }
}
struct LicenseView: View {
    @State var text = ""
    var url: URL
    
    init(_ url: URL) {
        self.url = url
    }
    var body: some View {
        Form {
            Section {
                if !text.isEmpty {
                    Text(text)
                } else {
                    HStack {
                        Spacer()
                        LoadingElement()
                        Spacer()
                    }
                }
            }
        }.formStyle(.grouped)
            .scrollContentBackground(.hidden)
            .task {
                DispatchQueue(label: "License load").async {
                    let licenseText = (try? String(contentsOf: url, encoding: .utf8)) ?? "error"
                    DispatchQueue.main.sync {
                        text = licenseText
                    }
                }
            }
    }
}

struct LogsView: View {
    
    struct Log: Hashable, Identifiable {
        let id = UUID()
        let timestamp: String
        let level: Level?
        let content: String
        
        enum Level: String {
            case INFO
            case WARN
            case DEBUG
            case TRACE
            case ERROR
            
            var color: Color {
                switch self {
                case .INFO:
                        .clear
                case .WARN:
                        .yellow
                case .DEBUG:
                        .orange
                case .TRACE:
                        .blue
                case .ERROR:
                        .red
                }
            }
        }
    }
    
    @State var logs: [Log] = []
    var url: URL
    
    init(_ url: URL) {
        self.url = url
    }
    
    var body: some View {
        Form {
            Section {
                if !logs.isEmpty {
                    List {
                        ForEach(logs) { log in
                            HStack {
                                Text(log.timestamp)
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                    .frame(width: 45)
                                Group {
                                    if log.level != nil {
                                        Text(log.level!.rawValue)
                                            .font(.callout)
                                            .frame(width: 43)
                                    }
                                    Text(log.content)
                                        .textSelection(.enabled)
                                }
                            }.listRowBackground(
                                (log.level?.color ?? .clear)
                                    .opacity(0.2)
                            )
                        }
                    }
                } else {
                    HStack {
                        Spacer()
                        LoadingElement()
                        Spacer()
                    }
                }
            }
            Text("The 100 last logs lines have been displayed. Click on the toolbar folder icon to open the log folders and access full logs.")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .padding()
                .foregroundStyle(.secondary)
        }.formStyle(.grouped)
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        url.showInFinder()
                    }, label: {
                        Label("Open logs folder", systemImage: "folder")
                    })
                }
            }
            .task {
                DispatchQueue(label: "Logs load").async {
                    let logsText = (try? String(contentsOf: url, encoding: .utf8)) ?? "error"
                    var array = Array(logsText.split(separator: "\n"))
                    for log in array.dropFirst(array.count-100) {
                        if let match = log.firstMatch(of: #/\[([A-Z])+\]/#)?.output.0, let level = LogsView.Log.Level(rawValue: "\(match)".replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "[", with: "")) {
                            DispatchQueue.main.sync {
                                logs.append(.init(timestamp: "\(log.dropLast(log.count-8))", level: level, content: String(log.dropFirst(8)).replacing(#/\[([A-Z])+\]/#, with: "")))
                            }
                        } else {
                            DispatchQueue.main.sync {
                                logs.append(.init(timestamp: "\(log.dropLast(log.count-8))", level: nil, content: String(log.dropFirst(8))))
                            }
                        }
                    }
                }
            }
            .clipped()
            .onDisappear {
                logs = []
            }
    }
                            
}
