//
//  TODOItem.swift
//  mvc-mvvm
//
//  Created by Ricky on 25/5/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import Foundation

struct TodoItem {
    
    let title: String
    let description: String
    let date: TimeInterval
    let uid: String
    let id: String?
    
    func dateString() -> String {
        let date = Date(timeIntervalSince1970: self.date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyy HH:mm (EEE)"
        return dateFormatter.string(from: date)
    }
    
}
