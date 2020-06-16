//
//  DataService.swift
//  mvc-mvvm
//
//  Created by Ricky on 25/5/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import Firebase
import RxSwift

protocol DataServiceProtocol: class {
    func addTodoItem(todoItem: TodoItem) -> Observable<Void>
    func getTodoList(uid: String) -> Observable<[TodoItem]>
    func deleteTodoItem(id: String) -> Observable<Void>
    func saveProfile(name: String) -> Observable<Void>
    func removeListener()
}

class DataService: DataServiceProtocol {
    
    let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    func addTodoItem(todoItem: TodoItem) -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in
            self.db.collection(K.FStore.todolist).addDocument(
                data: [K.FStore.title: todoItem.title,
                       K.FStore.description: todoItem.description,
                       K.FStore.date: todoItem.date,
                       K.FStore.uid: todoItem.uid]) { error in
                        if let e = error {
                            observer.onError(e)
                        } else {
                            observer.onNext(())
                        }
            }
            return Disposables.create()
        }
    }
    
    func getTodoList(uid: String) -> Observable<[TodoItem]> {
        return Observable<[TodoItem]>.create { observer -> Disposable in
            self.listener = self.db.collection(K.FStore.todolist)
                .whereField(K.FStore.uid, isEqualTo: uid)
                .order(by: K.FStore.date)
                .addSnapshotListener { (snapshot, error) in
                    if let e = error {
                        observer.onError(e)
                    } else {
                        var todoList = [TodoItem]()
                        if let documents = snapshot?.documents {
                            for document in documents {
                                let id = document.documentID
                                let data  = document.data()
                                if let title = data[K.FStore.title] as? String,
                                    let description = data[K.FStore.description] as? String,
                                    let date = data[K.FStore.date] as? TimeInterval,
                                    let uid = data[K.FStore.uid] as? String {
                                    let todoItem = TodoItem(title: title, description: description, date: date, uid: uid, id: id)
                                    todoList.append(todoItem)
                                }
                            }
                            observer.onNext(todoList)
                        }
                    }
            }
            return Disposables.create()
        }
    }
    
    func removeListener() {
        listener?.remove()
    }
    
    func deleteTodoItem(id: String) -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in
            self.db.collection(K.FStore.todolist)
                .document(id)
                .delete { error in
                    if let e = error {
                        observer.onError(e)
                    } else {
                        observer.onNext(())
                    }
            }
            return Disposables.create()
        }
    }
    
    func saveProfile(name: String) -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in
            if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                changeRequest.displayName = name
                changeRequest.commitChanges { error in
                    if let e = error {
                        observer.onError(e)
                    } else {
                        if let name = Auth.auth().currentUser?.displayName {
                            var user = User()
                            user.setName(name: name)
                        }
                        observer.onNext(())
                    }
                }
            }
            return Disposables.create()
        }
    }
    
}
