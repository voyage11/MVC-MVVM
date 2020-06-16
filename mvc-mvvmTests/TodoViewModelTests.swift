//
//  TodoViewModelTests.swift
//  mvc-mvvmTests
//
//  Created by Ricky on 16/6/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import XCTest
import RxSwift
@testable import mvc_mvvm

class TodoViewModelTests: XCTestCase {

    fileprivate var dataService: MockDataService!
    private let disposeBag = DisposeBag()
    var sut: TodoViewModel!
    private var user = User()

    override func setUp() {
        super.setUp()
        self.dataService = MockDataService()
        self.sut = TodoViewModel(dataService: self.dataService)
        user.setEmailUid(email: "a@a.com", uid: "1")
    }

    override func tearDown() {
        self.dataService = nil
        self.sut = nil
        user.setEmailUid(email: nil, uid: nil)
        super.tearDown()
    }
    
    func testGetTodoList() {
        let todoItems = StubGenerator().stubTodoItems()
        let expect = XCTestExpectation(description: "reload tableView")
        sut.todoCellViewModels
            .asObservable()
            .subscribe(onNext: { _ in
                expect.fulfill()
            }).disposed(by: disposeBag)
        sut.getTodoList()
        XCTAssertEqual(sut.todoCellViewModels.value.count, todoItems.count)
        wait(for: [expect], timeout: 1.0)
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
