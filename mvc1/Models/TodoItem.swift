//
//  TODOItem.swift
//  mvc1
//
//  Created by RandomMac on 25/5/20.
//  Copyright © 2020 RandomMac. All rights reserved.
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
