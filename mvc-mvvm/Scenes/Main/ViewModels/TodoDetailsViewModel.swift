//
//  TodoDetailsViewModel.swift
//  mvc-mvvm
//
//  Created by Ricky on 13/6/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class TodoDetailsViewModel {
    
    private let dataService: DataService
    private let disposeBag = DisposeBag()
    private let loading = BehaviorRelay(value: false)
    
    let todoCellViewModel: TodoCellViewModel
    let onShowMessage = PublishSubject<AlertMessage>()
    let onNextNavigation = PublishSubject<Void>()
    var onShowLoading: Observable<Bool> {
        return loading
            .asObservable()
            .distinctUntilChanged()
    }
        
    init(dataService: DataService, todoCellViewModel: TodoCellViewModel) {
        self.dataService = dataService
        self.todoCellViewModel = todoCellViewModel
    }
    
    func deleteTodoItem(id: String) {
        self.loading.accept(true)
        dataService.deleteTodoItem(id: id)
            .subscribe(
                onNext: { [weak self] in
                    self?.loading.accept(false)
                    let alertMessage = AlertMessage(title: "Success", message:"The TODO item is completed.", alertType: .success)
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

