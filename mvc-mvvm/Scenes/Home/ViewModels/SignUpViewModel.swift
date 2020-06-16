//
//  SignUpViewModel.swift
//  mvc-mvvm
//
//  Created by Ricky on 13/6/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel {
    
    private let authService: AuthenticationServiceProtocol
    private let disposeBag = DisposeBag()
    private let loading = BehaviorRelay(value: false)
    
    let title = "Signup"
    let onShowMessage = PublishSubject<AlertMessage>()
    let onNextNavigation = PublishSubject<Void>()
    var onShowLoading: Observable<Bool> {
        return loading
            .asObservable()
            .distinctUntilChanged()
    }
    
    var email = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    var errorType: AlertErrorType? {
        didSet {
            self.onShowMessage.onNext(AlertMessageType.message(errorType!))
        }
    }
    
    init(authService: AuthenticationServiceProtocol) {
        self.authService = authService
    }
    
    func signUp() {
        if email.value == "" {
            self.errorType = .emailRequired
        } else if password.value == "" {
            self.errorType = .passwordRequired
        } else {
            loading.accept(true)
            let autheticationModel = Authentication(email: email.value, password: password.value)
            authService.signUp(authentication: autheticationModel).subscribe(
                onNext: { [weak self] in
                    self?.loading.accept(false)
                    self?.errorType = .signUpSuccess
                    self?.onNextNavigation.onNext(())
                },
                onError: { [weak self] error in
                    self?.loading.accept(false)
                    self?.errorType = .error(error.localizedDescription)
                }
            ).disposed(by: disposeBag)
        }
    }
    
    deinit {
        if K.showPrint {
            print("\(String(describing: type(of: self))) deinit")
        }
    }
}
