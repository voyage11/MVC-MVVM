//
//  MockDataService.swift
//  mvc-mvvmTests
//
//  Created by Ricky on 16/6/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import Foundation

import RxSwift
@testable import mvc_mvvm

class MockDataService: DataServiceProtocol {

    var completeTodoItems: [TodoItem] = [TodoItem]()

    func addTodoItem(todoItem: TodoItem) -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in
            observer.onNext(())
            return Disposables.create()
        }
    }
    
    func getTodoList(uid: String) -> Observable<[TodoItem]> {
        return Observable<[TodoItem]>.create { observer -> Disposable in
            let path = Bundle.main.path(forResource: "todoitems", ofType: "json")!
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let todoItems = try! decoder.decode([TodoItem].self, from: data)
            observer.onNext(todoItems)
            return Disposables.create()
        }
    }
    
    func deleteTodoItem(id: String) -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in
            if let firstIndex = self.completeTodoItems.firstIndex(where: { $0.id == id }) {
                self.completeTodoItems.remove(at: firstIndex)
                observer.onNext(())
            } else {
                observer.onError(APIError.todoItemNotFound)
            }
            return Disposables.create()
        }
    }
    
    func saveProfile(name: String) -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in
            observer.onNext(())
            return Disposables.create()
        }
    }
    
    func removeListener() {}
    
}
