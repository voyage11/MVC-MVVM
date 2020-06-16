//
//  AddTodoViewModel.swift
//  mvc-mvvm
//
//  Created by Ricky on 13/6/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class AddTodoViewModel {
    
    private let dataService: DataServiceProtocol
    private let disposeBag = DisposeBag()
    private let loading = BehaviorRelay(value: false)
    
    let title = "Add a TODO Item"
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
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }
    
    func addTodoItem(todoItem: TodoItem) {
        if todoItem.title == ""  {
            self.errorType = .todoTitleRequired
        } else if todoItem.description == ""  {
            self.errorType = .todoDescriptionRequired
        } else {
            self.loading.accept(true)
            dataService.addTodoItem(todoItem: todoItem)
                .subscribe(
                    onNext: { [weak self] in
                        self?.loading.accept(false)
                        self?.errorType = .todoItemAdded
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

