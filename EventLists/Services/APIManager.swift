//
//  APIManager.swift
//  EventLists
//
//  Created by YOU-HSUAN YU on 2020/11/14.
//

import Foundation

enum Endpoint: String {
    case events = "https://us-central1-techtaskapi.cloudfunctions.net/events"
}

protocol APIManagerProtocol {
    func fetchEvents(by page: String, completion: @escaping (Result<EventList, APIError>) -> Void)
}

class APIManager: APIManagerProtocol {
    
    func fetchEvents(by page: String, completion: @escaping (Result<EventList, APIError>) -> Void) {
        fetch(by: page, endpoint: Endpoint.events.rawValue) { (eventListResult: Result<EventList, APIError>)  in
            completion(eventListResult)
        }
    }
    
    func fetch<T: Decodable>(by page: String, endpoint: String, completion: @escaping (Result<T, APIError>) -> Void) {
        var component = URLComponents(string: endpoint)
        component?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)")
        ]
        guard let url = component?.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(.failure(APIError.requestFailed(error)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(APIError.invalidResponse))
                return
            }
            guard let data = data else {
                completion(.failure(APIError.invalidData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let objects = try decoder.decode(T.self, from: data)
                completion(.success(objects))
            } catch {
                completion(.failure(APIError.invalidData))
            }
        }
        dataTask.resume()
    }
}
