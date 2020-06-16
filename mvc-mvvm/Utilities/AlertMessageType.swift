//
//  AlertMessageType.swift
//  mvc-mvvm
//
//  Created by Ricky on 16/6/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import Foundation

enum AlertErrorType: Equatable {
    case emailRequired
    case passwordRequired
    case loginSuccess
    case signUpSuccess
    case todoItemAdded
    case todoItemCompleted
    case nameIsSaved
    case logoutSuccess
    case todoTitleRequired
    case todoDescriptionRequired
    case idIsRequired
    case nameIsRequired
    case error(_ errorMessage: String)
}

struct AlertMessageType {
    
    static func message(_ type: AlertErrorType) -> AlertMessage {
        var alertMessage: AlertMessage!
        switch type {
            case .emailRequired:
                alertMessage = AlertMessage(title: "Email Required", message: "Please enter your email.", alertType: .error)
            case .passwordRequired:
                alertMessage = AlertMessage(title: "Password Required", message: "Please enter your password.", alertType: .error)
            case .loginSuccess:
                alertMessage = AlertMessage(title: "Success", message: "Welcome Back!", alertType: .success)
            case .signUpSuccess:
                alertMessage = AlertMessage(title: "Success", message: "Thanks for siging up!", alertType: .success)
            case .todoItemAdded:
                alertMessage = AlertMessage(title: "Success", message:"The TODO item is added.", alertType: .success)
            case .todoItemCompleted:
                alertMessage = AlertMessage(title: "Success", message:"The TODO item is completed.", alertType: .success)
            case .nameIsSaved:
                alertMessage = AlertMessage(title: "Success", message:"Name is saved successfully.", alertType: .success)
            case .logoutSuccess:
                alertMessage = AlertMessage(title: "Success", message: "Logout successfully.", alertType: .success)
            case .todoTitleRequired:
                alertMessage = AlertMessage(title: "Title Required", message: "Please enter todo item's title.", alertType: .error)
            case .todoDescriptionRequired:
                alertMessage = AlertMessage(title: "Description Required", message: "Please enter todo item's description.", alertType: .error)
            case .idIsRequired:
                alertMessage = AlertMessage(title: "Id is Required", message: "Todo item is required.", alertType: .error)
            case .nameIsRequired:
                alertMessage = AlertMessage(title: "Name is Required", message: "Name is required.", alertType: .error)
            case .error(let errorMessage):
                alertMessage = AlertMessage(title: "Error", message: errorMessage, alertType: .error)
        }
        return alertMessage
    }
    
}
