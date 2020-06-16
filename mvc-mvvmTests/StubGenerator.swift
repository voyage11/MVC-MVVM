//
//  StubGenerator.swift
//  mvc-mvvmTests
//
//  Created by Ricky on 16/6/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import Foundation
@testable import mvc_mvvm

class StubGenerator {
    func stubTodoItems() -> [TodoItem] {
        let path = Bundle.main.path(forResource: "todoitems", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let todoItems = try! decoder.decode([TodoItem].self, from: data)
        return todoItems
    }
}
