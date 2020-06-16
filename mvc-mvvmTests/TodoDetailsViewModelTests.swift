//
//  TodoDetailsViewModelTests.swift
//  mvc-mvvmTests
//
//  Created by Ricky on 16/6/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import XCTest
@testable import mvc_mvvm

class TodoDetailsViewModelTests: XCTestCase {

    fileprivate var dataService: MockDataService!
    var sut: TodoDetailsViewModel!
    
    override func setUp() {
        super.setUp()
        self.dataService = MockDataService()
        let todoItem = TodoItem(title: "title", description: "description", date: Date().timeIntervalSince1970, uid: "1", id: "1")
        let todoCellViewModel = TodoCellViewModel(todoItem: todoItem)
        self.sut = TodoDetailsViewModel(dataService: self.dataService, todoCellViewModel: todoCellViewModel)
    }
    
    override func tearDown() {
        self.dataService = nil
        self.sut = nil
        super.tearDown()
    }
    
    func testDeleteTodoItem() {
      let todoItems = StubGenerator().stubTodoItems()
      dataService.completeTodoItems = todoItems
      
      //Invalid Id
      sut.deleteTodoItem(id: "6")
      XCTAssertEqual(sut.errorType, AlertErrorType.error(APIError.todoItemNotFound.localizedDescription))

      //Complete 1 item
      sut.deleteTodoItem(id: "1")
      XCTAssertEqual(sut.errorType, AlertErrorType.todoItemCompleted)
      XCTAssertEqual(dataService.completeTodoItems.count, todoItems.count - 1)
    }
}
