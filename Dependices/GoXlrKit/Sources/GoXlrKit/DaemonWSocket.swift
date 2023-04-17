//
//  DaemonWSocket.swift
//  
//
//  Created by Adélaïde Sky on 16/04/2023.
//

import Foundation
import Starscream
import SwiftyJSON
import os

/**
 Daemon WebSocket manager. Allows control over a goxlr-utility's daemon websocket instance.
 */
public class DaemonWSocket: WebSocketDelegate {
    
    var socketConnexionStatus: SocketConnexionStatus = .disconnected
    var socket: WebSocket? = nil
    @Published public var holdUpdates: Bool = false
    
    public enum SocketConnexionStatus: String, CaseIterable, Codable {
        case disconnected
        case connecting
        case connected
        case error
    }
    
    /**
     Connects to the goxlr-utility's websocket.
     - Parameters:
        - host: Name, as string, of the host. Default is `localhost`
        - port: Port to connect to. Default is `14564`
     */
    public func connect(host: String = "localhost", port: Int = 14564) {
        var request = URLRequest(url: URL(string: "http://\(host):\(port)/api/websocket")!)
        request.timeoutInterval = 5
        
        self.socket = WebSocket(request: request)
        socket?.delegate = self
        self.socketConnexionStatus = .connecting
        socket?.connect()
    }
    
    /**
     Disconnects from the previously connected websocket.
     */
    public func disconnect() {
        guard socket != nil else {
            Logger().error("No socket connected.")
            return
        }
        
        socket?.disconnect()
    }
    
    /**
     Sends a string command to the connected websocket.
     */
    public func sendCommand(string: String) {
        guard socket != nil else {
            Logger().error("No socket connected to write to.")
            return
        }
        
        socket?.write(string: string, completion: {
            if GoXlr.shared.logLevel == .debug {
                Logger().debug("Sent command: \(string)")
            }
        })
    }
    /**
     Function responsible for handliing incoming websocket calls.
     */
    public func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
        switch event {
        case .connected(let headers):
            self.socketConnexionStatus = .connected
            Logger().info("Daemon websocket is connected: \(headers)")
            socket?.write(string: "{\"id\": 0, \"data\": \"GetStatus\"}") {}
        case .disconnected(let reason, let code):
            self.socketConnexionStatus = .disconnected
            Logger().info("Daemon websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            if string.contains("Status") {
                if GoXlr.shared.logLevel == .debug {
                    Logger().debug("Recived status: \(string)")
                }
                do {
                    GoXlr.shared.status = try JSONDecoder().decode(Status.self, from: string.data(using: .utf8)!)
                } catch {
                    Logger().error("\(error)")
                }
                GoXlr.shared.device = GoXlr.shared.status?.data.status.mixers.first?.key ?? ""
            } else {
                if !self.holdUpdates {
                    let json = JSON(parseJSON: string)
                    for patch in json["data"]["Patch"].arrayValue {
                        if patch["path"].stringValue.starts(with: "/mixers/") {
                            let device = patch["path"].stringValue.components(separatedBy: "/")[2]
                            do {
                                var statusJSON = try JSON(data: try JSONEncoder().encode(GoXlr.shared.status!.data.status.mixers[device]!))
                                
                                statusJSON[Array(patch["path"].stringValue.components(separatedBy: "/").dropFirst(3))] = patch["value"]
                                GoXlr.shared.status!.data.status.mixers[device]! = try JSONDecoder().decode(Mixer.self, from: try statusJSON.rawData())
                            } catch let error {
                                Logger().error("\(error)")
                            }
                        } else {
                            do {
                                var statusJSON = try JSON(data: try JSONEncoder().encode(GoXlr.shared.status!.data.status))
                                statusJSON[Array(patch["path"].stringValue.components(separatedBy: "/"))] = patch["value"]
                                GoXlr.shared.status!.data.status = try JSONDecoder().decode(StatusClass.self, from: try statusJSON.rawData())
                            } catch let error {
                                Logger().error("\(error)")
                            }
                        }
                    }
                }
            }
        case .binary(let data):
            Logger().info("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            self.socketConnexionStatus = .disconnected
        case .error(let error):
            self.socketConnexionStatus = .error
            Logger().error("\(error)")
        }
    }
}
