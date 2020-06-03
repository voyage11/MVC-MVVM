//
//  AuthenticationServices.swift
//  mvc-mvvm
//
//  Created by Ricky on 24/5/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import Firebase

struct AuthenticationService {
    
    func login(authentication: Authentication, completion: @escaping (_ errorMessage: String?) -> Void) {
        Auth.auth().signIn(withEmail: authentication.email,
                           password: authentication.password)
        { authResult, error in
            if let e = error {
                completion(e.localizedDescription)
            } else {
                var user = User()
                if let email = Auth.auth().currentUser?.email,
                    let uid = Auth.auth().currentUser?.uid {
                    user.setEmailUid(email: email, uid: uid)
                }
                if let name = Auth.auth().currentUser?.displayName {
                    user.setName(name: name)
                }
                completion(nil)
            }
        }
    }
    
    func signUp(authentication: Authentication, completion: @escaping (_ errorMessage: String?) -> Void) {
        Auth.auth().createUser(withEmail: authentication.email,
                               password: authentication.password)
        { authResult, error in
            if let e = error {
                print(e)
                completion(e.localizedDescription)
            } else {
                if let email = Auth.auth().currentUser?.email,
                    let uid = Auth.auth().currentUser?.uid {
                    var user = User()
                    user.setEmailUid(email: email, uid: uid)
                }
                completion(nil)
            }
        }
    }
    
    func logout(completion: @escaping (_ errorMessage: String?) -> Void) {
        do {
            try Auth.auth().signOut()
            var user = User()
            user.setEmailUid(email: nil, uid: nil)
            user.setName(name: nil)
            completion(nil)
        }
        catch {
            completion(error.localizedDescription)
        }
    }
    
}

