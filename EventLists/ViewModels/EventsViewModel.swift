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
    
    // Pagination properties
    private var currentPage: Int = 0
    private var pageSize: Int = 0
    private var total: Int = 0
    
    // Tableview's data source
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
                self.pageSize = eventList.pageSize
                self.total = eventList.total
                
                self.events += eventList.items
                    
                self.delegate?.finishFetchingEvents()
            case .failure(let apiError):
                print("APIError occurs: \(apiError)")
            }
        }
    }
    
    
}

// MARK: - Pagination
extension EventsViewModel {
    func loadMoreIfNeeded(at index: Int) {
        if shouldLoadMore(at: index) {
            currentPage += 1
            fetchEvents()
        }
    }
    
    func shouldLoadMore(at index: Int) -> Bool {
        return (index == events.count - 1) && ((currentPage + 1) * pageSize < total)
    }
}
