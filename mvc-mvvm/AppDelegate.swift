//
//  AppDelegate.swift
//  mvc-mvvm
//
//  Created by Ricky on 24/5/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        let user = User()
        let storyboard = UIStoryboard(name: K.StoryboardID.Main, bundle: nil)
        if user.email != nil {
            if let navVC = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.TodoNavigationController) as? UINavigationController {
                if let todoViewController = navVC.viewControllers.first as? TodoViewController {
                    todoViewController.viewModel = TodoViewModel()
                }
                window?.rootViewController = navVC
                window?.makeKeyAndVisible()
            }
        } else {
            let InitialNavigationController = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.InitialNavigationController)
            window?.rootViewController = InitialNavigationController
            window?.makeKeyAndVisible()
        }
        
        return true
    }

}

