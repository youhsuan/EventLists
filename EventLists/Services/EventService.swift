//
//  EventService.swift
//  EventLists
//
//  Created by YOU-HSUAN YU on 2020/11/14.
//

import Foundation

protocol EventServiceProtocol {
    var apiManager: APIManagerProtocol { get }
    func fetchEvents(by page: String, completion: @escaping (Result<EventList, APIError>) -> Void)
}

class EventService: EventServiceProtocol {
    var apiManager: APIManagerProtocol
    
    init(apiManager: APIManagerProtocol) {
        self.apiManager = apiManager
    }
    
    func fetchEvents(by page: String, completion: @escaping (Result<EventList, APIError>) -> Void) {
        
        apiManager.fetchEvents(by: page) { (eventListResult) in
            completion(eventListResult)
        }
    }
}
