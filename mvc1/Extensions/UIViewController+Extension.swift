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
    
    func showMessage(title: String, message: String, errorBool: Bool, successBool: Bool) {
        let error = MessageView.viewFromNib(layout: .messageView)
        error.button?.isHidden = true
        var errorConfig = SwiftMessages.defaultConfig
        errorConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        if errorBool {
            error.configureTheme(.error)
        } else if successBool {
            let image = #imageLiteral(resourceName: "successIcon")
            error.configureTheme(backgroundColor: UIColor(named: "successBackground")!, foregroundColor: .white, iconImage: image, iconText: nil)
        } else {
            let image = #imageLiteral(resourceName: "warningIcon")
            error.configureTheme(backgroundColor: UIColor(named: "warningBackground")!, foregroundColor: UIColor(named: "warningColor")!, iconImage: image, iconText: nil)
        }
        error.configureContent(title: title, body: message)
        SwiftMessages.show(config: errorConfig, view: error)
    }
    
}
