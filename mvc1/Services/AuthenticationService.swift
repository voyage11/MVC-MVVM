//
//  AuthenticationServices.swift
//  mvc1
//
//  Created by RandomMac on 24/5/20.
//  Copyright © 2020 RandomMac. All rights reserved.
//

import Firebase
import RxSwift

struct AuthenticationService {
    
    func login(authentication: Authentication) -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in
            Auth.auth().signIn(withEmail: authentication.email,
                               password: authentication.password)
            { _, error in
                if let e = error {
                    observer.onError(e)
                } else {
                    var user = User()
                    if let email = Auth.auth().currentUser?.email,
                        let uid = Auth.auth().currentUser?.uid {
                        user.setEmailUid(email: email, uid: uid)
                    }
                    if let name = Auth.auth().currentUser?.displayName {
                        user.setName(name: name)
                    }
                    observer.onNext(())
                }
            }
            return Disposables.create()
        }
    }
    
    func signUp(authentication: Authentication) -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in
            Auth.auth().createUser(withEmail: authentication.email,
                               password: authentication.password)
            { _, error in
                if let e = error {
                    observer.onError(e)
                } else {
                    if let email = Auth.auth().currentUser?.email,
                        let uid = Auth.auth().currentUser?.uid {
                        var user = User()
                        user.setEmailUid(email: email, uid: uid)
                    }
                    observer.onNext(())
                }
            }
            return Disposables.create()
        }
    }
    
    func logout() -> Observable<Void>  {
        return Observable<Void>.create { observer -> Disposable in
            do {
                try Auth.auth().signOut()
                var user = User()
                user.setEmailUid(email: nil, uid: nil)
                user.setName(name: nil)
                observer.onNext(())
            }
            catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
}

