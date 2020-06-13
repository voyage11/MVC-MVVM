//
//  AppCoordinator.swift
//  mvc-mvvm
//
//  Created by Ricky on 8/6/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import UIKit
import Firebase

class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    lazy var navigationController: UINavigationController = {
        return UINavigationController(rootViewController: UIViewController())
    }()
    
    override func start() {
        guard let window = window else {
            return
        }
        let user = User()
        if user.email != nil {
            showTodoViewController()
        } else {
            showHomeViewController()
        }
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    override func finish() {
        for coordinator in childCoordinators {
            coordinator.finish()
            if let coordinator = coordinator as? MainCoordinator {
                coordinator.delegate = nil
            }
            if let coordinator = coordinator as? HomeCoordinator {
                coordinator.delegate = nil
            }
        }
        removeAllChildCoordinators()
        navigationController.popToRootViewController(animated: false)
    }
    
}

extension AppCoordinator: HomeCoordinatorDelegate, MainCoordinatorDelegate {
    
    func showTodoViewController() {
        finish()
        let storyboard = UIStoryboard(name: K.StoryboardID.Main, bundle: nil)
        let todoVC = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.TodoViewController) as! TodoViewController
        todoVC.viewModel = TodoViewModel(dataService: DataService())
        let mainCoordinator = MainCoordinator(rootViewController: todoVC, navigationController: navigationController)
        addChildCoordinator(mainCoordinator)
        mainCoordinator.delegate = self
        navigationController.setViewControllers([todoVC], animated: false)
        mainCoordinator.start()
    }
    
    func showHomeViewController() {
        finish()
        let storyboard = UIStoryboard(name: K.StoryboardID.Home, bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.HomeViewController) as! HomeViewController
        let homeCoordinator = HomeCoordinator(rootViewController: homeVC, navigationController: navigationController)
        addChildCoordinator(homeCoordinator)
        homeCoordinator.delegate = self
        navigationController.setViewControllers([homeVC], animated: false)
        homeCoordinator.start()
    }
    
}
 
