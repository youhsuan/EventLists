//
//  AppCoordinator.swift
//  EventLists
//
//  Created by YOU-HSUAN YU on 2020/11/14.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

final class AppCoordinator: Coordinator {
    
    private static let apiManager = APIManager()
    private static let storageManager = StorageManager()
    private static let networkManager = NetworkManager()
    
    var navigationController: UINavigationController

    let eventService = EventService(apiManager: apiManager,
                                    storageManager: storageManager,
                                    networkManager: networkManager)
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = EventsViewModel(eventService: eventService)
        let eventListVC = EventListViewController(viewModel: viewModel)
        navigationController.pushViewController(eventListVC, animated: true)
        
    }
}
