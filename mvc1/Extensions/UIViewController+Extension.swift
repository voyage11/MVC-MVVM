//
//  UIViewController+Extension.swift
//  mvc1
//
//  Created by RandomMac on 24/5/20.
//  Copyright © 2020 RandomMac. All rights reserved.
//

import UIKit
import SwiftMessages

extension UIViewController {
    
    func showMessage(title: String, message: String, alertType: AlertType) {
        DispatchQueue.main.async {
            let error = MessageView.viewFromNib(layout: .messageView)
            error.button?.isHidden = true
            var errorConfig = SwiftMessages.defaultConfig
            errorConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
            switch(alertType) {
            case .success:
                let image = #imageLiteral(resourceName: "successIcon")
                error.configureTheme(backgroundColor: UIColor(named: "successBackground")!, foregroundColor: .white, iconImage: image, iconText: nil)
                break
            case .warning:
                let image = #imageLiteral(resourceName: "warningIcon")
                error.configureTheme(backgroundColor: UIColor(named: "warningBackground")!, foregroundColor: UIColor(named: "warningColor")!, iconImage: image, iconText: nil)
                break
            default:
                error.configureTheme(.error)
            }
            error.configureContent(title: title, body: message)
            SwiftMessages.show(config: errorConfig, view: error)
        }
    }
    
    func moveToTODOViewController() {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let window = appDelegate.window {
                let storyboard = UIStoryboard(name: K.StoryboardID.Main, bundle: nil)
                let TodoNavigationController = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.TodoNavigationController)
                window.rootViewController = TodoNavigationController
                window.makeKeyAndVisible()
            }
        }
    }
    
    func moveToInitialViewController() {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let window = appDelegate.window {
                let storyboard = UIStoryboard(name: K.StoryboardID.Main, bundle: nil)
                let TodoNavigationController = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.InitialNavigationController)
                window.rootViewController = TodoNavigationController
                window.makeKeyAndVisible()
            }
        }
    }
    
}
