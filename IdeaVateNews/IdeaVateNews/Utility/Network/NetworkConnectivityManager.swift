//
//  NetworkConnectivityManager.swift
//  IdeaVateNews
//
//  Created by Ashish Shukla on 03/11/20.
//  Copyright © 2020 Ashish. All rights reserved.
//

import UIKit
import Reachability

class NetworkConnectivityManager: NSObject {
    var reachability: Reachability!
    static let sharedInstance: NetworkConnectivityManager = {
        return NetworkConnectivityManager()
    }()
    override init() {
        super.init()
        // Initialise reachability
        do {
            try reachability = Reachability()
            // Register an observer for the network status
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(networkStatusChanged(_:)),
                name: .reachabilityChanged,
                object: reachability
            )
            try reachability.startNotifier()
        } catch {
            print("This is not working.")
        }
        
    }
    @objc func networkStatusChanged(_ notification: Notification) {
        // Do something globally here!
    }
    static func stopNotifier() -> Void {
        do {
            // Stop the network status notifier
            try (NetworkConnectivityManager.sharedInstance.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }
    // Network is reachable
    static func isReachable(completed: @escaping (NetworkConnectivityManager) -> Void) {
        if (NetworkConnectivityManager.sharedInstance.reachability).connection != .unavailable {
            completed(NetworkConnectivityManager.sharedInstance)
        }
    }
    // Network is unreachable
    static func isUnreachable(completed: @escaping (NetworkConnectivityManager) -> Void) {
        if (NetworkConnectivityManager.sharedInstance.reachability).connection == .unavailable {
            completed(NetworkConnectivityManager.sharedInstance)
        }
    }
    // Network is reachable via WWAN/Cellular
    static func isReachableViaWWAN(completed: @escaping (NetworkConnectivityManager) -> Void) {
        if (NetworkConnectivityManager.sharedInstance.reachability).connection == .cellular {
            completed(NetworkConnectivityManager.sharedInstance)
        }
    }
    // Network is reachable via WiFi
    static func isReachableViaWiFi(completed: @escaping (NetworkConnectivityManager) -> Void) {
        if (NetworkConnectivityManager.sharedInstance.reachability).connection == .wifi {
            completed(NetworkConnectivityManager.sharedInstance)
        }
    }
}
