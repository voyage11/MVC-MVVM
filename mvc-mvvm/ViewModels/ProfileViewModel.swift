//
//  ProfileViewModel.swift
//  mvc-mvvm
//
//  Created by Ricky on 13/6/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel {
    
    private let authService: AuthenticationService
    private let dataService: DataService
    private let disposeBag = DisposeBag()
    private let loading = BehaviorRelay(value: false)
    
    let title = "Profile"
    let onShowMessage = PublishSubject<AlertMessage>()
    let onNextNavigation = PublishSubject<Void>()
    let onLogout = PublishSubject<Void>()
    var onShowLoading: Observable<Bool> {
        return loading
            .asObservable()
            .distinctUntilChanged()
    }
    
    var email = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    
    init(authService: AuthenticationService, dataService: DataService) {
        self.authService = authService
        self.dataService = dataService
    }
    
    func logout() {
        loading.accept(true)
        authService.logout().subscribe(
            onNext: { [weak self] in
                self?.loading.accept(false)
                let alertMessage = AlertMessage(title: "Success", message: "Logout successfully.", alertType: .success)
                self?.onShowMessage.onNext(alertMessage)
                self?.onLogout.onNext(())
            },
            onError: { [weak self] error in
                self?.loading.accept(false)
                let alertMessage = AlertMessage(title: "Error", message: error.localizedDescription, alertType: .error)
                self?.onShowMessage.onNext(alertMessage)
            }
        ).disposed(by: disposeBag)
    }
    
    func saveProfile(name: String) {
        self.loading.accept(true)
        dataService.saveProfile(name: name)
            .subscribe(
                onNext: { [weak self] in
                    self?.loading.accept(false)
                    let alertMessage = AlertMessage(title: "Success", message:"Name is saved successfully.", alertType: .success)
                    self?.onShowMessage.onNext(alertMessage)
                    self?.onNextNavigation.onNext(())
                },
                onError: { [weak self] error in
                    self?.loading.accept(false)
                    let alertMessage = AlertMessage(title: "Error", message: error.localizedDescription, alertType: .error)
                    self?.onShowMessage.onNext(alertMessage)
                }
        ).disposed(by: disposeBag)
    }
    
    deinit {
        if K.showPrint {
            print("\(String(describing: type(of: self))) deinit")
        }
    }
}
