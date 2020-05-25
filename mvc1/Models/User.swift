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
    var firstName: String?
    var lastName: String?
    
    init() {
        self.email = UserDefaults.standard.value(forKey: K.User.email) as? String ?? nil
        self.uid = UserDefaults.standard.value(forKey: K.User.uid) as? String ?? nil
        self.firstName = UserDefaults.standard.value(forKey: K.User.firstName) as? String ?? nil
        self.lastName = UserDefaults.standard.value(forKey: K.User.lastName) as? String ?? nil
        //print("email: \(self.email)")
    }
    
    mutating func setEmailUid(email: String, uid: String) {
        print("setEmailUid: \(email) uid: \(uid)")
        self.email = email
        self.uid = uid
        UserDefaults.standard.setValue(email, forKey: K.User.email)
        UserDefaults.standard.setValue(uid, forKey: K.User.uid)
        UserDefaults.standard.synchronize()
    }
    
    mutating func setName(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
        UserDefaults.standard.setValue(firstName, forKey: K.User.firstName)
        UserDefaults.standard.setValue(lastName, forKey: K.User.lastName)
        UserDefaults.standard.synchronize()
    }
    
}
