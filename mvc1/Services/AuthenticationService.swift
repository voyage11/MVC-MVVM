//
//  AuthenticationServices.swift
//  mvc1
//
//  Created by RandomMac on 24/5/20.
//  Copyright © 2020 RandomMac. All rights reserved.
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
                completion(nil)
                //TODO: Somehow need to save a token locally
                
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
                completion(nil)
                //TODO: Somehow need to save a token?

            }
        }
    }
    
}

