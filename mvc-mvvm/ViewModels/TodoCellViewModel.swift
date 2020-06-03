//
//  TodoCellViewModel.swift
//  mvc-mvvm
//
//  Created by Ricky on 30/5/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import Foundation

struct TodoCellViewModel {
    
    var title: String
    var date: TimeInterval
    var description: String
    var uid: String
    var id: String?
    
    init(todoItem: TodoItem) {
        self.title = todoItem.title
        self.date = todoItem.date
        self.description = todoItem.description
        self.uid = todoItem.uid
        self.id = todoItem.id
    }
    
    func dateString() -> String {
        let date = Date(timeIntervalSince1970: self.date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyy HH:mm (EEE)"
        return dateFormatter.string(from: date)
    }
}
