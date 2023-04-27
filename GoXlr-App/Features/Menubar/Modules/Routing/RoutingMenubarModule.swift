//
//  RoutingMenubarModule.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 27/04/2023.
//

import SwiftUI
import GoXlrKit

fileprivate extension InputDevice {
    var index: Int {
        switch self {
        case .Microphone:
            return 0
        case .Chat:
            return 1
        case .Music:
            return 2
        case .Game:
            return 3
        case .Console:
            return 4
        case .LineIn:
            return 5
        case .System:
            return 6
        case .Samples:
            return 7
        }
    }
}

struct RoutingMenubarModule: View {
    @ObservedObject var configuration = AppSettings.shared.mmodsSettings.routing
    
    var body: some View {
        HStack {
            RoutingMenubarRoute(route: $configuration.route1)
            
            if configuration.route2.input != nil && configuration.route2.output != nil {
                Divider()
                RoutingMenubarRoute(route: $configuration.route2)
                
                if configuration.route3.input != nil && configuration.route3.output != nil {
                    Divider()
                    RoutingMenubarRoute(route: $configuration.route3)
                }
            }
        }.frame(height: 50)
            .padding(.vertical)
    }
}
struct RoutingMenubarRoute: View {
    @Binding var route: MmodRouterRoute
    @ObservedObject var router = GoXlr.shared.mixer!.router
    
    var body: some View {
        switch route.output {
        case .BroadcastMix:
            MenubarCheckboxRoutingView(channelin: route.input!,
                                       channelout: route.output!,
                                       chanIndex: route.input!.index,
                                       state: router.everyBroadcastMix)
        case .ChatMic:
            MenubarCheckboxRoutingView(channelin: route.input!,
                                       channelout: route.output!,
                                       chanIndex: route.input!.index,
                                       state: router.everyChatMic)
        case .Headphones:
            MenubarCheckboxRoutingView(channelin: route.input!,
                                       channelout: route.output!,
                                       chanIndex: route.input!.index,
                                       state: router.everyHeadphones)
        case .LineOut:
            MenubarCheckboxRoutingView(channelin: route.input!,
                                       channelout: route.output!,
                                       chanIndex: route.input!.index,
                                       state: router.everyLineOut)
        case .Sampler:
            MenubarCheckboxRoutingView(channelin: route.input!,
                                       channelout: route.output!,
                                       chanIndex: route.input!.index,
                                       state: router.everySampler)
        case .none:
            EmptyView()
        }
    }
}
struct MenubarCheckboxRoutingView: View {
    let channelin: InputDevice
    let channelout: OutputDevice
    let chanIndex: Int
    var state: [Binding<Bool>]
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: channelin.icon)
                    .scaledToFit()
                Text("→")
                    .font(.system(size: 13))
                    .fontWeight(.light)
                Image(systemName: channelout.icon)
                    .scaledToFit()
            }
            Toggle("", isOn: state[chanIndex])
                .toggleStyle(BigCheckboxStyle())
                .scaleEffect(0.7)
        }.padding(.horizontal, 9)
    }
}
