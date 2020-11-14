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
    
    var events: [EventDetail] = []
    
    init(eventService: EventServiceProtocol) {
        self.eventService = eventService
    }
    
    func retrieveEventsFromCoreData() {
        eventService.retrieveEventsFromCoreData { (result) in
            switch result {
            case .success(let eventsFromLocal):
                self.events = eventsFromLocal
                self.delegate?.finishFetchingEvents()
            case .failure(let error):
                // TODO: Error-handling
                print(error)
            }
        }
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
                
                let _ = eventList.items.map {
                    let model = EventDetail(event: $0)
                    self.events.append(model)
                    
                    // Sync to CoreData
                    self.syncToCoreData(model: model)
                }
                
                self.delegate?.finishFetchingEvents()
            case .failure(let apiError):
                print("APIError occurs: \(apiError)")
            }
        }
    }
    
    private func syncToCoreData(model: EventModel) {
        eventService.syncToCoreData(model: model)
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
