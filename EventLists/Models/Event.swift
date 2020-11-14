//
//  Event.swift
//  EventLists
//
//  Created by YOU-HSUAN YU on 2020/11/14.
//

import Foundation

struct Event: Decodable {
    let id: String
    let title: String
    let image: String
    let startDate: Int
}

extension Event: EventCellDisplayable {
    var date: String {
        return String(startDate)
    }
    var isFavorite: Bool {
        return false
    }
}
