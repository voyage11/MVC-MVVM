//
//  APIError.swift
//  mvc-mvvm
//
//  Created by Ricky on 16/6/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import Foundation

public enum APIError: Error {
    case invalidEmailOrPassword
    case emailAlreadyInUse
    case todoItemNotFound
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidEmailOrPassword:
            return NSLocalizedString("Invalid Email or Password", comment: "")
        case .emailAlreadyInUse:
            return NSLocalizedString("Email is already in used by another account", comment: "")
        case .todoItemNotFound:
            return NSLocalizedString("Todo Item not found", comment: "")
        }
    }
}
