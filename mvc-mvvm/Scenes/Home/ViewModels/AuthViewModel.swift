//
//  AuthViewModel.swift
//  mvc-mvvm
//
//  Created by Ricky on 28/5/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


final class AuthViewModel {
    private let authService: AuthenticationService
    private let disposeBag = DisposeBag()
    private let loading = BehaviorRelay(value: false)
    
    let onShowMessage = PublishSubject<AlertMessage>()
    let onShowTodoViewController = PublishSubject<Void>()
    var onShowLoading: Observable<Bool> {
        return loading
            .asObservable()
            .distinctUntilChanged()
    }
    
    var email = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    
    init(authService: AuthenticationService) {
        self.authService = authService
    }
    
    func login() {
        if email.value == "" {
            let alertMessage = AlertMessage(title: "Email Required", message: "Please enter your email.", alertType: .error)
            self.onShowMessage.onNext(alertMessage)
        } else if password.value == "" {
            let alertMessage = AlertMessage(title: "Password Required", message: "Please enter your password.", alertType: .error)
            self.onShowMessage.onNext(alertMessage)
        } else {
            loading.accept(true)
            let autheticationModel = Authentication(email: email.value, password: password.value)
            authService.login(authentication: autheticationModel).subscribe(
                onNext: { [weak self] in
                    self?.loading.accept(false)
                    let alertMessage = AlertMessage(title: "Success", message: "Welcome Back!", alertType: .success)
                    self?.onShowMessage.onNext(alertMessage)
                    self?.onShowTodoViewController.onNext(())
                },
                onError: { [weak self] error in
                    self?.loading.accept(false)
                    let alertMessage = AlertMessage(title: "Error", message: error.localizedDescription, alertType: .error)
                    self?.onShowMessage.onNext(alertMessage)
                }
            ).disposed(by: disposeBag)
        }
    }
    
    func signUp() {
        if email.value == "" {
            let alertMessage = AlertMessage(title: "Email Required", message: "Please enter your email.", alertType: .error)
            self.onShowMessage.onNext(alertMessage)
        } else if password.value == "" {
            let alertMessage = AlertMessage(title: "Password Required", message: "Please enter your password.", alertType: .error)
            self.onShowMessage.onNext(alertMessage)
        } else {
            loading.accept(true)
            let autheticationModel = Authentication(email: email.value, password: password.value)
            authService.signUp(authentication: autheticationModel).subscribe(
                onNext: { [weak self] in
                    self?.loading.accept(false)
                    let alertMessage = AlertMessage(title: "Success", message: "Thanks for siging up!", alertType: .success)
                    self?.onShowMessage.onNext(alertMessage)
                    self?.onShowTodoViewController.onNext(())
                },
                onError: { [weak self] error in
                    self?.loading.accept(false)
                    let alertMessage = AlertMessage(title: "Error", message: error.localizedDescription, alertType: .error)
                    self?.onShowMessage.onNext(alertMessage)
                }
            ).disposed(by: disposeBag)
        }
    }
    
}




