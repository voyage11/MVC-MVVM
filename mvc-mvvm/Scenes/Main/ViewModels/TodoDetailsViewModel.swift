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
    
    private let dataService: DataServiceProtocol
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
    
    var errorType: AlertErrorType? {
        didSet {
            self.onShowMessage.onNext(AlertMessageType.message(errorType!))
        }
    }
    
    init(dataService: DataServiceProtocol, todoCellViewModel: TodoCellViewModel) {
        self.dataService = dataService
        self.todoCellViewModel = todoCellViewModel
    }
    
    func deleteTodoItem(id: String) {
        self.loading.accept(true)
        dataService.deleteTodoItem(id: id)
            .subscribe(
                onNext: { [weak self] in
                    self?.loading.accept(false)
                    self?.errorType = .todoItemCompleted
                    self?.onNextNavigation.onNext(())
                },
                onError: { [weak self] error in
                    self?.loading.accept(false)
                    self?.errorType = .error(error.localizedDescription)
                }
        ).disposed(by: disposeBag)
    }
    
    deinit {
        if K.showPrint {
            print("\(String(describing: type(of: self))) deinit")
        }
    }
}

