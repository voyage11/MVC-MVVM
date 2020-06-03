//
//  DataService.swift
//  mvc-mvvm
//
//  Created by Ricky on 25/5/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import Firebase

struct DataService {

    let db = Firestore.firestore()

    func addTodoItem(todoItem: TodoItem, completion: @escaping (_ errorMessage: String?) -> Void) {
        db.collection(K.FStore.todolist).addDocument(
            data: [K.FStore.title: todoItem.title,
                   K.FStore.description: todoItem.description,
                   K.FStore.date: todoItem.date,
                   K.FStore.uid: todoItem.uid]) { error in
                    if let e = error {
                        completion(e.localizedDescription)
                    } else {
                        completion(nil)
                    }
        }
    }
       
    func getTodoList(uid: String, completion: @escaping (_ errorMessage: String?, _ todoList: [TodoItem]?) -> Void) {
        db.collection(K.FStore.todolist)
            .whereField(K.FStore.uid, isEqualTo: uid)
            .order(by: K.FStore.date)
            .addSnapshotListener { (snapshot, error) in
                if let e = error {
                    print(e)
                    completion(e.localizedDescription, nil)
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
                        completion(nil, todoList)
                    }
                }
        }
    }
    
    func deleteTodoItem(id: String, completion: @escaping (_ errorMessage: String?) -> Void) {
        db.collection(K.FStore.todolist)
            .document(id)
            .delete { error in
                if let e = error {
                    completion(e.localizedDescription)
                } else {
                    completion(nil)
                }
        }
    }
    
    func saveProfile(name: String, completion: @escaping (_ errorMessage: String?) -> Void) {
        if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
            changeRequest.displayName = name
            changeRequest.commitChanges { error in
                if let e = error {
                    completion(e.localizedDescription)
                } else {
                    if let name = Auth.auth().currentUser?.displayName {
                        var user = User()
                        user.setName(name: name)
                    }
                    completion(nil)
                }
            }
        }
     }
    
    

}
