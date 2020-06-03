//
//  SignUp.swift
//  mvc-mvvm
//
//  Created by Ricky on 24/5/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import Foundation

struct Authentication {
    
    let email: String
    let password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
}
