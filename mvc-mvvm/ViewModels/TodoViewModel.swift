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
    
    private let dataService: DataService
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
    
    init(dataService: DataService) {
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
                        let alertMessage = AlertMessage(title: "Error", message: error.localizedDescription, alertType: .error)
                        self?.onShowMessage.onNext(alertMessage)
                    }
            ).disposed(by: disposeBag)
        }
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
        dataService.removeListener()
    }
}
