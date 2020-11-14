//
//  SceneDelegate.swift
//  EventLists
//
//  Created by YOU-HSUAN YU on 2020/11/14.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let appCoordinator = AppCoordinator()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let viewModel = EventsViewModel(eventService: appCoordinator.eventService)
        let eventListVC = EventListViewController(viewModel: viewModel)
        let rootVC = UINavigationController(rootViewController: eventListVC)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        appCoordinator.networkManager.startMonitoring()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        appCoordinator.networkManager.stopMonitoring()
    }


}

