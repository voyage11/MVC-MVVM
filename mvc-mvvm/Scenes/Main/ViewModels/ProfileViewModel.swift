//
//  ProfileViewModel.swift
//  mvc-mvvm
//
//  Created by Ricky on 9/6/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel {
    
    private let authService: AuthenticationServiceProtocol
    private let dataService: DataServiceProtocol

    let title = "Profile"
    private let disposeBag = DisposeBag()
    private let loading = BehaviorRelay(value: false)
    
    let onShowMessage = PublishSubject<AlertMessage>()
    let onNextNavigation = PublishSubject<Void>()
    let onShowHomeViewController = PublishSubject<Void>()
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
    
    init(authService: AuthenticationServiceProtocol, dataService: DataServiceProtocol) {
        self.authService = authService
        self.dataService = dataService
    }
    
    func logout() {
        loading.accept(true)
        authService.logout().subscribe(
            onNext: { [weak self] in
                self?.loading.accept(false)
                self?.errorType = .logoutSuccess
                self?.onShowHomeViewController.onNext(())
            },
            onError: { [weak self] error in
                self?.loading.accept(false)
                self?.errorType = .error(error.localizedDescription)
            }
        ).disposed(by: disposeBag)
    }
    
    func saveProfile(name: String) {
        if name == "" {
            self.errorType = .nameIsRequired
        } else {
            self.loading.accept(true)
            dataService.saveProfile(name: name)
                .subscribe(
                    onNext: { [weak self] in
                        self?.loading.accept(false)
                        self?.errorType = .nameIsSaved
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




