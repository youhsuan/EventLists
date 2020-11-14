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
    
    func fetchData() {
        if eventService.isConnectedToNetwork() {
            fetchEvents()
        } else {
            retrieveEventsFromCoreData()
        }
    }
    
    private func retrieveEventsFromCoreData() {
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
    
    private func fetchEvents() {
        eventService.fetchEvents(by: String(currentPage)) {[weak self] (eventListResult) in
            guard let self = self else { return }
            switch eventListResult {
            case .success(let eventList):
                self.setPaginationProperties(from: eventList)
                self.mappingEventDetailObject(from: eventList)
                
            case .failure(let apiError):
                print("APIError occurs: \(apiError)")
            }
        }
    }
    
    private func setPaginationProperties(from eventList: EventList) {
        self.currentPage = eventList.page
        self.pageSize = eventList.pageSize
        self.total = eventList.total
    }
    
    private func mappingEventDetailObject(from eventList: EventList) {
        for event in eventList.items {
            getFavoriteStatusAndMap(to: event)
        }
        self.delegate?.finishFetchingEvents()
    }
    
    private func getFavoriteStatusAndMap(to event: Event) {
        eventService.getFavoriteStatus(for: event) { (favoriteResult) in
            switch favoriteResult {
            case .success(let isFavorite):
                let model = EventDetail(event: event, isFavorite: isFavorite)
                self.events.append(model)
                
                // Sync to CoreData
                self.syncToCoreData(model: model)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateFavoriteStatusToCoreData(with model: EventModel) {
        eventService.updateFavoriteStatus(model: model)
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
    
    private func shouldLoadMore(at index: Int) -> Bool {
        return (index == events.count - 1) && ((currentPage + 1) * pageSize < total)
    }
}
