//
//  AppCoordinator.swift
//  mvc-mvvm
//
//  Created by RandomMac on 8/6/20.
//  Copyright © 2020 RandomMac. All rights reserved.
//

import UIKit
import Firebase

class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    let window: UIWindow?
    //let db = Firestore.firestore()
    
    lazy var rootViewController: UINavigationController = {
        return UINavigationController(rootViewController: UIViewController())
    }()
    
    // MARK: - Coordinator
    init(window: UIWindow?) {
        self.window = window
    }

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
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }

    override func finish() {
        
    }
    
}

extension AppCoordinator: HomeCoordinatorDelegate, MainCoordinatorDelegate {
    
    func showTodoViewController() {
        removeAllChildCoordinators()
        if let vc = rootViewController.viewControllers.last {
            vc.navigationController?.popToRootViewController(animated: false)
        }
        let storyboard = UIStoryboard(name: K.StoryboardID.Main, bundle: nil)
        let todoVC = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.TodoViewController) as! TodoViewController
        todoVC.viewModel = TodoViewModel(dataService: DataService())
        let mainCoordinator = MainCoordinator(rootViewController: todoVC)
        mainCoordinator.delegate = self
        rootViewController.setViewControllers([todoVC], animated: false)
        mainCoordinator.start()
    }
    
    func showHomeViewController() {
        removeAllChildCoordinators()
        if let vc = rootViewController.viewControllers.last {
            vc.navigationController?.popToRootViewController(animated: false)
        }
        let storyboard = UIStoryboard(name: K.StoryboardID.Home, bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.HomeViewController) as! HomeViewController
        let homeCoordinator = HomeCoordinator(rootViewController: homeVC)
        addChildCoordinator(homeCoordinator)
        homeCoordinator.delegate = self
        rootViewController.setViewControllers([homeVC], animated: false)
        homeCoordinator.start()
    }
    
}
 
