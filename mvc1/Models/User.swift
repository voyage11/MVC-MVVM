//
//  File.swift
//  mvc1
//
//  Created by RandomMac on 25/5/20.
//  Copyright © 2020 RandomMac. All rights reserved.
//

import Foundation

struct User {
    
    var email: String?
    var uid: String?
    var name: String?
    
    init() {
        self.email = UserDefaults.standard.value(forKey: K.User.email) as? String ?? nil
        self.uid = UserDefaults.standard.value(forKey: K.User.uid) as? String ?? nil
        self.name = UserDefaults.standard.value(forKey: K.User.name) as? String ?? nil
    }
    
    mutating func setEmailUid(email: String?, uid: String?) {
        self.email = email
        self.uid = uid
        UserDefaults.standard.setValue(email, forKey: K.User.email)
        UserDefaults.standard.setValue(uid, forKey: K.User.uid)
        UserDefaults.standard.synchronize()
    }
    
    mutating func setName(name: String?) {
        self.name = name
        UserDefaults.standard.setValue(name, forKey: K.User.name)
        UserDefaults.standard.synchronize()
    }
    
}
