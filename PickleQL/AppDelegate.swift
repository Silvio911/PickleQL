//
//  AppDelegate.swift
//  PickleQL
//
//  Created by Silvio Bulla on 23.03.25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        // Ideally, the Coordinator's start() method would be used here to initiate the flow.
        let navigationController = UINavigationController(
            rootViewController: CharacterListViewController(viewModel: CharacterListViewModel())
        )
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}

