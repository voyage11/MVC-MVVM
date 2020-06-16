//
//  AddTodoViewModelTests.swift
//  mvc-mvvmTests
//
//  Created by Ricky on 16/6/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import XCTest
import RxSwift
@testable import mvc_mvvm

class AddTodoViewModelTests: XCTestCase {

    fileprivate var dataService: MockDataService!
    private let disposeBag = DisposeBag()
    var sut: AddTodoViewModel!
    
    override func setUp() {
        super.setUp()
        self.dataService = MockDataService()
        self.sut = AddTodoViewModel(dataService: self.dataService)
    }

    override func tearDown() {
        self.dataService = nil
        self.sut = nil
        super.tearDown()
    }
    
    func testAddTodoItem() {
        var todoItem = TodoItem(title: "", description: "", date: Date().timeIntervalSince1970, uid: "1", id: nil)
        
        //Title Not Entered
        sut.addTodoItem(todoItem: todoItem)
        XCTAssertEqual(sut.errorType, AlertErrorType.todoTitleRequired)

        //Description Not Entered
        todoItem = TodoItem(title: "Title", description: "", date: Date().timeIntervalSince1970, uid: "1", id: nil)
        sut.addTodoItem(todoItem: todoItem)
        XCTAssertEqual(sut.errorType, AlertErrorType.todoDescriptionRequired)
        
        //Item Added
        let expect = XCTestExpectation(description: "move to TodayViewController")
        sut.onNextNavigation
            .asObservable()
            .subscribe(onNext: { _ in
                expect.fulfill()
            }).disposed(by: disposeBag)
        todoItem = TodoItem(title: "Title", description: "Description", date: Date().timeIntervalSince1970, uid: "1", id: nil)
        sut.addTodoItem(todoItem: todoItem)
        XCTAssertEqual(sut.errorType, AlertErrorType.todoItemAdded)
        wait(for: [expect], timeout: 1.0)
    }

}
