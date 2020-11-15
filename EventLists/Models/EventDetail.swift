//
//  EventDetail.swift
//  EventLists
//
//  Created by YOU-HSUAN YU on 2020/11/14.
//

import Foundation
import CoreData

protocol EventModel {
    var event: Event { get }
    var isFavorite: Bool { get set }
}

class EventDetail: EventModel {
    var event: Event
    var isFavorite: Bool
    
    init(event: Event, isFavorite: Bool) {
        self.event = event
        self.isFavorite = isFavorite
    }
    
    init?(_ object: NSManagedObject) {
        guard
            let id = object.value(forKey: "id") as? String,
            let title = object.value(forKey: "title") as? String,
            let image = object.value(forKey: "image") as? String,
            let date = object.value(forKey: "date") as? Int,
            let isFavorite = object.value(forKey: "isFavorite") as? Bool
        else { return nil }
        self.event = Event(id: id, title: title, image: image, startDate: date)
        self.isFavorite = isFavorite
    }
}

// For displaying EventTableViewCell
extension EventDetail: EventCellDisplayable {
    var title: String {
        return event.title
    }
    
    var image: String {
        return event.image
    }
    
    var date: String {
        let dateString = String(event.startDate)
        return dateString.dateFormatted(pattern: "EEEE HH:mm")
    }
}
