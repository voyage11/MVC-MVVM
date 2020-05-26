//
//  AppDelegate.swift
//  mvc1
//
//  Created by RandomMac on 24/5/20.
//  Copyright © 2020 RandomMac. All rights reserved.
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
            let TodoNavigationController = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.TodoNavigationController)
            window?.rootViewController = TodoNavigationController
            window?.makeKeyAndVisible()
        } else {
            let InitialNavigationController = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.InitialNavigationController)
            window?.rootViewController = InitialNavigationController
            window?.makeKeyAndVisible()
        }
        
        return true
    }

}

