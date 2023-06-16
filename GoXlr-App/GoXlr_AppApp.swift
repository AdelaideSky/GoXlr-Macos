//
//  GoXlr_AppApp.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 27/12/2022.
//

import SwiftUI
import GoXlrKit
import Sparkle
import Sentry
import SentrySwiftUI
import AppKit


// This view model class publishes when new updates can be checked by the user
final class CheckForUpdatesViewModel: ObservableObject {
    @Published var canCheckForUpdates = false

    init(updater: SPUUpdater) {
        updater.publisher(for: \.canCheckForUpdates)
            .assign(to: &$canCheckForUpdates)
    }
}
extension NSWindow /* actually NSStatusBarWindow but it's a private AppKit type */ {
    /// When called on an `NSStatusBarWindow` instance, returns the associated `NSStatusItem`.
    /// Always returns `nil` for any other `NSWindow` subclass.
    @_disfavoredOverload
    func fetchStatusItem() -> NSStatusItem? {
        // statusItem is a private key not exposed to Swift but we can get it using Key-Value coding
        value(forKey: "statusItem") as? NSStatusItem
        ?? Mirror(reflecting: self).descendant("statusItem") as? NSStatusItem
    }
}
// This is the view for the Check for Updates menu item
// Note this intermediate view is necessary for the disabled state on the menu item to work properly before Monterey.
// See https://stackoverflow.com/questions/68553092/menu-not-updating-swiftui-bug for more info
struct CheckForUpdatesView: View {
    @ObservedObject private var checkForUpdatesViewModel: CheckForUpdatesViewModel
    private let updater: SPUUpdater
    
    init(updater: SPUUpdater) {
        self.updater = updater
        
        // Create our view model for our CheckForUpdatesView
        self.checkForUpdatesViewModel = CheckForUpdatesViewModel(updater: updater)
    }
    
    var body: some View {
        Button("Check for Updates…", action: updater.checkForUpdates)
            .disabled(!checkForUpdatesViewModel.canCheckForUpdates)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    @Environment(\.openWindow) private var openWindow
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        NSApp.setActivationPolicy(.accessory)
        return false
    }
    
    func application(_ application: NSApplication, open urls: [URL]) {
        if urls.first!.pathExtension == "goxlr" {
            GoXlr.shared.importProfile(urls.first!, path: .profiles)
            GoXlr.shared.command(.LoadProfile(String(urls.first!.lastPathComponent.dropLast(6))))
        }
        if urls.first!.pathExtension == "goxlrMicProfile" {
            GoXlr.shared.importProfile(urls.first!, path: .micprofiles)
            GoXlr.shared.command(.LoadMicProfile(String(urls.first!.lastPathComponent.dropLast(16))))
        }
        if urls.first!.pathExtension == "preset" {
            GoXlr.shared.importProfile(urls.first!, path: .presets)
        }
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        
        if let window = NSApplication.shared.windows.first {
            window.close()
        }
        
        if AppSettings.shared.firstLaunch {
            
            NSApplication.shared.setActivationPolicy(.regular)
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 500, height: 550),
                styleMask: [.titled],
                backing: .buffered,
                defer: false)
            window.identifier = .init("onboarding")
            window.animationBehavior = .utilityWindow
//            window.animat
            window.center()
            window.titlebarAppearsTransparent = true
            window.isReleasedWhenClosed = false
            window.contentView = NSHostingView(rootView: OnboardingView())
            window.orderFrontRegardless()
            
        }
        
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(systemWillSleep(_:)), name: NSWorkspace.screensDidSleepNotification, object: nil)
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(systemDidWake(_:)), name: NSWorkspace.didWakeNotification, object: nil)
        
        GoXlr.shared.observationStore = AppSettings.shared.$observationStore
        GoXlr.shared.startObserving()
    }
    
    @objc func systemWillSleep(_ notification: Notification) {
        for command in AppSettings.shared.sleepCommands {
            GoXlr.shared.command(command)
        }
    }
    
    @objc func systemDidWake(_ notification: Notification) {
        for command in AppSettings.shared.wakeCommands {
            GoXlr.shared.command(command)
        }
    }
    func applicationWillTerminate(_ notification: Notification) {
        for command in AppSettings.shared.shutdownCommands {
            GoXlr.shared.command(command)
        }
        GoXlr.shared.stopObserving()
    }
}

@main
struct GoXlr_AppApp: App {
    private let updaterController: SPUStandardUpdaterController
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var settings = AppSettings.shared
    
    init() {
        // If you want to start the updater manually, pass false to startingUpdater and call .startUpdater() later
        // This is where you can also pass an updater delegate if you need one
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
        SentrySDK.start { options in
            options.dsn = "https://c3679fb415ce46298b304d33b27238cb@o4505192929820672.ingest.sentry.io/4505192931131392"
            options.initialScope = { scope in
                    scope.setTag(value: "my value", key: "my-tag")
                    return scope
                }
            // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
            // We recommend adjusting this value in production.
            options.tracesSampleRate = 1.0
        }
    }
    
    var body: some Scene {
        Group {
            Group {
                ConfigurationScene()
                SettingsScene()
            }.commands {
                CommandGroup(after: .appInfo) {
                    CheckForUpdatesView(updater: updaterController.updater)
                }
            }
            
            MenubarScene()
        }.commands {
            if settings.firstLaunch {
                CommandGroup(replacing: CommandGroupPlacement.appSettings, addition: {
                    Button("Settings...") {}
                        .disabled(true)
                })
            }
        }
            
    }
}
