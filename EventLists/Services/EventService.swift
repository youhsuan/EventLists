//
//  EventService.swift
//  EventLists
//
//  Created by YOU-HSUAN YU on 2020/11/14.
//

import Foundation

protocol EventServiceProtocol {
    var apiManager: APIManagerProtocol { get }
    var storageManager: StorageManagerProtocol { get }
    func fetchEvents(by page: String, completion: @escaping (Result<EventList, APIError>) -> Void)
    func syncToCoreData(model: EventModel)
}

class EventService: EventServiceProtocol {
    var apiManager: APIManagerProtocol
    var storageManager: StorageManagerProtocol
    
    init(apiManager: APIManagerProtocol, storageManager: StorageManagerProtocol) {
        self.apiManager = apiManager
        self.storageManager = storageManager
    }
    
    func fetchEvents(by page: String, completion: @escaping (Result<EventList, APIError>) -> Void) {
        apiManager.fetchEvents(by: page) { (eventListResult) in
            completion(eventListResult)
        }
    }
    
    func syncToCoreData(model: EventModel) {
        storageManager.checkIfExisted(model: model) { (checkExistedResult) in
            switch checkExistedResult {
            case .success(let isExisted):
                if isExisted {
                    // If existed, then update event.
                    storageManager.update(model: model)
                } else {
                    storageManager.save(model: model)
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
