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
    
}
