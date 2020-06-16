//
//  TodoViewModel.swift
//  mvc-mvvm
//
//  Created by Ricky on 30/5/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class TodoViewModel {
    
    private let dataService: DataServiceProtocol
    private let disposeBag = DisposeBag()
    private let loading = BehaviorRelay(value: false)
    
    let title = "TODO"
    let onShowMessage = PublishSubject<AlertMessage>()
    let onNextNavigation = PublishSubject<Void>()
    var onShowLoading: Observable<Bool> {
        return loading
            .asObservable()
            .distinctUntilChanged()
    }
    
    var todoCellViewModels = BehaviorRelay<[TodoCellViewModel]>(value: [])
    var errorType: AlertErrorType? {
        didSet {
            self.onShowMessage.onNext(AlertMessageType.message(errorType!))
        }
    }
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }
    
    func getTodoList() {
        self.loading.accept(true)
        let user = User()
        if let uid = user.uid {
            dataService.getTodoList(uid: uid)
                .subscribe(
                    onNext: { [weak self] todolist in
                        self?.loading.accept(false)
                        var todoCellViewModels = [TodoCellViewModel]()
                        for todoItem in todolist {
                            todoCellViewModels.append(TodoCellViewModel(todoItem: todoItem))
                        }
                        self?.todoCellViewModels.accept(todoCellViewModels)
                    },
                    onError: { [weak self] error in
                        self?.loading.accept(false)
                        self?.errorType = .error(error.localizedDescription)
                    }
            ).disposed(by: disposeBag)
        }
    }
    
    func deleteTodoItem(id: String) {
        if id == "" {
            self.errorType = .idIsRequired
        } else {
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
    }
    
    deinit {
        if K.showPrint {
            print("\(String(describing: type(of: self))) deinit")
        }
        dataService.removeListener()
    }
    
}
