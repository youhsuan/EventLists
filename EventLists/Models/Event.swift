//
//  Event.swift
//  EventLists
//
//  Created by YOU-HSUAN YU on 2020/11/14.
//

import Foundation

protocol EventModel {
//    var id: String { get }
//    var title: String { get }
//    var image: String { get }
//    var startDate: Int { get }
    var event: Event { get }
    var isFavorite: Bool { get }
}

struct EventFullInfo: EventModel {
    var event: Event
    var isFavorite: Bool
}

struct Event: Decodable {
    var id: String
    var title: String
    var image: String
    var startDate: Int
}

extension Event: EventCellDisplayable {
    var date: String {
        return String(startDate)
    }
    var isFavorite: Bool {
        //TOFIX: Should get from CoreData
        return false
    }
}
