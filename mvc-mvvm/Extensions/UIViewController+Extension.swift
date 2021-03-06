//
//  UIViewController+Extension.swift
//  mvc-mvvm
//
//  Created by Ricky on 24/5/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import UIKit
import SwiftMessages
import NVActivityIndicatorView

extension UIViewController: NVActivityIndicatorViewable {
    
    func showMessage(alertMessage: AlertMessage) {
        DispatchQueue.main.async {
            let error = MessageView.viewFromNib(layout: .messageView)
            error.button?.isHidden = true
            var errorConfig = SwiftMessages.defaultConfig
            errorConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
            switch(alertMessage.alertType) {
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
            error.configureContent(title: alertMessage.title, body: alertMessage.message)
            SwiftMessages.show(config: errorConfig, view: error)
        }
    }
    
    func moveToTODOViewController() {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let window = appDelegate.window {
                let storyboard = UIStoryboard(name: K.StoryboardID.Main, bundle: nil)
                if let navVC = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.TodoNavigationController) as? UINavigationController {
                    if let todoViewController = navVC.viewControllers.first as? TodoViewController {
                        todoViewController.viewModel = TodoViewModel(dataService: DataService())
                    }
                    window.rootViewController = navVC
                    window.makeKeyAndVisible()
                }
            }
        }
    }
    
    func moveToInitialViewController() {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let window = appDelegate.window {
                let storyboard = UIStoryboard(name: K.StoryboardID.Main, bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.InitialNavigationController)
                window.rootViewController = vc
                window.makeKeyAndVisible()
            }
        }
    }
    
}
