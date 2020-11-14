//
//  EventList.swift
//  EventLists
//
//  Created by YOU-HSUAN YU on 2020/11/14.
//

import Foundation

struct EventList: Decodable {
    let page: Int
    let total: Int
    let pageSize: Int
    let items: [Event]
}
