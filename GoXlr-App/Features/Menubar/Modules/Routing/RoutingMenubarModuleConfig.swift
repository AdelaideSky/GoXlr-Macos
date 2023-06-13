//
//  RoutingMenubarModuleConfig.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 26/04/2023.
//

import SwiftUI
import GoXlrKit

class RoutingMenubarModuleConfig: ObservableObject {
    
    @AppStorage(AppSettingsKeys.mmodRouter_Route1.rawValue)
    var route1: MmodRouterRoute = .init(input: InputDevice.Microphone, output: OutputDevice.BroadcastMix)
    
    @AppStorage(AppSettingsKeys.mmodRouter_Route2.rawValue)
    var route2: MmodRouterRoute = .init(input: nil, output: nil)
    
    @AppStorage(AppSettingsKeys.mmodRouter_Route3.rawValue)
    var route3: MmodRouterRoute = .init(input: nil, output: nil)
}

struct MmodRouterRoute: Codable, RawRepresentable {
    var input: InputDevice?
    var output: OutputDevice?
    
    init(input: InputDevice?, output: OutputDevice?) {
        self.input = input
        self.output = output
    }
    
    enum CodingKeys: String, CodingKey {
        case input, output
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            input = try values.decode(InputDevice?.self, forKey: .input)
        } catch { input = nil }
        do {
            output = try values.decode(OutputDevice?.self, forKey: .output)
        } catch { output = nil }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(input, forKey: .input)
        try container.encode(output, forKey: .output)
    }
    
    init?(rawValue: String) {
        do {
            guard let data = rawValue.data(using: .utf8) else {
                return nil
            }
            let result = try JSONDecoder().decode(MmodRouterRoute.self, from: data)
            self = result
        } catch let error {
            print(error)
            return nil
        }
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
            let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

    

