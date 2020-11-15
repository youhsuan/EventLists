//
//  NotificationRegisteringProtocol.swift
//  EventLists
//
//  Created by YOU-HSUAN YU on 2020/11/14.
//

import Foundation

protocol NotificationRegisteringProtocol: class {
    func addObserver()
    func removeObserver()
}

extension NotificationRegisteringProtocol {
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
}

extension Notification.Name {
    static let networkStatusChanged = Notification.Name("networkStatusChanged")
}
