//
//  NetworkManager.swift
//  EventLists
//
//  Created by YOU-HSUAN YU on 2020/11/14.
//

import Foundation
import Network

protocol NetworkManagerProtocol {
    var isConnected: Bool { get }
    func startMonitoring()
    func stopMonitoring()
}

class NetworkManager: NetworkManagerProtocol {
    private var monitor: NWPathMonitor?
    private var isMonitoring: Bool = false
    
    var isConnected: Bool {
        guard let monitor = monitor else { return false }
        return monitor.currentPath.status == .satisfied
    }
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkStatus_Monitor")
        monitor?.start(queue: queue)
        
        monitor?.pathUpdateHandler = { _ in
            NotificationCenter.default.post(name: .networkStatusChanged, object: nil)
        }
        isMonitoring = true
    }
    
    func stopMonitoring() {
        guard isMonitoring, let monitor = monitor else { return }
        monitor.cancel()
        self.monitor = nil
        isMonitoring = false
    }
    
    deinit {
        stopMonitoring()
    }
}
