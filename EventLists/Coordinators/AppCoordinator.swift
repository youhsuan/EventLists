//
//  AppCoordinator.swift
//  EventLists
//
//  Created by YOU-HSUAN YU on 2020/11/14.
//

import Foundation

class AppCoordinator {
    
    let apiManager = APIManager()
    let storageManager = StorageManager()
    
    let eventService: EventService
    
    init() {
        eventService = EventService(apiManager: apiManager, storageManager: storageManager)
    }
    
}
