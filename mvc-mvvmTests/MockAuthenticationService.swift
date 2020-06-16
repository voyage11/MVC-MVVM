//
//  MockAuthenticationService.swift
//  mvc-mvvmTests
//
//  Created by Ricky on 15/6/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import Foundation
import RxSwift
@testable import mvc_mvvm

class MockAuthenticationService: AuthenticationServiceProtocol {
        
    private let existingEmail = "a@a.com"
    private let existingPassword = "abcd1234"
    
    func login(authentication: Authentication) -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in
            if authentication.email == self.existingEmail &&
                authentication.password == self.existingPassword {
                observer.onNext(())
            } else {
                observer.onError(APIError.invalidEmailOrPassword)
            }
            return Disposables.create()
        }
    }
    
    func signUp(authentication: Authentication) -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in
            if authentication.email == self.existingEmail &&
                authentication.password == self.existingPassword {
                observer.onError(APIError.emailAlreadyInUse)
            } else {
                observer.onNext(())
            }
            return Disposables.create()
        }
    }
    
    func logout() -> Observable<Void>  {
        return Observable<Void>.create { observer -> Disposable in
            var user = User()
            user.setEmailUid(email: nil, uid: nil)
            user.setName(name: nil)
            observer.onNext(())
            return Disposables.create()
        }
    }
    
}
