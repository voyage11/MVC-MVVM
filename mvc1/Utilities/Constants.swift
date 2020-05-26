//
//  Constants.swift
//  mvc1
//
//  Created by RandomMac on 25/5/20.
//  Copyright © 2020 RandomMac. All rights reserved.
//

import Foundation

struct K {
    
    struct Segue {
        static let showAddTodoViewController = "showAddTodoViewController"
        static let showProfileViewController = "showProfileViewController"
        static let showTODODetailsViewController = "showTODODetailsViewController"
    }
    
    struct TableCell {
        static let TODOTableViewCell = "TODOTableViewCell"
    }
    
    struct User {
        static let email = "email"
        static let uid = "uid"
        static let name = "name"
    }
    
    struct StoryboardID {
        static let Main = "Main"
        static let InitialNavigationController = "InitialNavigationController"
        static let TODONavigationController = "TODONavigationController"
    }
    
    struct FStore {
        static let todolist = "todolist"
        static let title = "title"
        static let description = "description"
        static let date = "date"
        static let uid = "uid"
        static let id = "id"
    }
    
}