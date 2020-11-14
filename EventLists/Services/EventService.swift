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
    var networkManager: NetworkManagerProtocol { get }
    func isConnectedToNetwork() -> Bool
    func syncToCoreData(model: EventModel)
    func fetchEvents(by page: String, completion: @escaping (Result<EventList, APIError>) -> Void)
    func retrieveEventsFromCoreData(completion: (Result<[EventDetail], StorageError>) -> Void)    
}

class EventService: EventServiceProtocol {
    var apiManager: APIManagerProtocol
    var storageManager: StorageManagerProtocol
    var networkManager: NetworkManagerProtocol
    
    init(apiManager: APIManagerProtocol,
         storageManager: StorageManagerProtocol,
         networkManager: NetworkManagerProtocol) {
        self.apiManager = apiManager
        self.storageManager = storageManager
        self.networkManager = networkManager
    }
    
    func isConnectedToNetwork() -> Bool {
        return networkManager.isConnected
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
                    storageManager.update(model: model)
                } else {
                    storageManager.save(model: model)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func retrieveEventsFromCoreData(completion: (Result<[EventDetail], StorageError>) -> Void) {
        storageManager.retrieve { (retrieveEventsResult) in
            completion(retrieveEventsResult)
        }
    }
}

// MARK: - Network monitoring method 
extension EventService {
    func startMonitoringNetwork() {
        networkManager.startMonitoring()
    }
    
    func stopMonitoringNetowrk() {
        networkManager.stopMonitoring()
    }
}
