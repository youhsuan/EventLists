//
//  Error.swift
//  EventLists
//
//  Created by YOU-HSUAN YU on 2020/11/14.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidData
    case invalidResponse
}

enum StorageError: Error {
    case fetchFailed
}
