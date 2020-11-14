//
//  EventsViewModel.swift
//  EventLists
//
//  Created by YOU-HSUAN YU on 2020/11/14.
//

import Foundation

protocol EventsViewModelDelegate: class {
    func finishFetchingEvents()
}

class EventsViewModel {
    
    var eventService: EventServiceProtocol
    weak var delegate: EventsViewModelDelegate?
    
    var currentPage: Int = 0
    var events: [Event] = []
    
    init(eventService: EventServiceProtocol) {
        self.eventService = eventService
    }
    
    func fetchEvents() {
        eventService.fetchEvents(by: String(currentPage)) {[weak self] (eventListResult) in
            guard let self = self else { return }
            switch eventListResult {
            case .success(let eventList):
                print(eventList)
                self.currentPage = eventList.page
                self.events = eventList.items
                self.delegate?.finishFetchingEvents()
            case .failure(let apiError):
                print("APIError occurs: \(apiError)")
            }
        }
    }
    
}
