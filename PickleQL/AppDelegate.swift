//
//  AppDelegate.swift
//  PickleQL
//
//  Created by Silvio Bulla on 23.03.25.
//

import UIKit
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        navigationController = UINavigationController()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        showSelectionView()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
    
    private func showSelectionView() {
        let selectionView = RootSelectionView { [weak self] implementationType in
            self?.navigateToImplementation(implementationType)
        }
        let hostingController = UIHostingController(rootView: selectionView)
        hostingController.title = "PickleQL"
        navigationController?.setViewControllers([hostingController], animated: false)
    }
    
    private func navigateToImplementation(_ type: ImplementationType) {
        switch type {
        case .uikit:
            let viewController = CharacterListViewController(viewModel: CharacterListViewModel())
            navigationController?.pushViewController(viewController, animated: true)
            
        case .swiftui:
            let swiftUIView = CharacterListView(viewModel: CharacterListViewModel())
            let hostingController = UIHostingController(rootView: swiftUIView)
            navigationController?.pushViewController(hostingController, animated: true)
        }
    }
}

