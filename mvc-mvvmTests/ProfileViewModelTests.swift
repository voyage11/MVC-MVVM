//
//  ProfileViewModelTests.swift
//  mvc-mvvmTests
//
//  Created by Ricky on 16/6/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import XCTest
import RxSwift
@testable import mvc_mvvm

class ProfileViewModelTests: XCTestCase {

    fileprivate var authService: MockAuthenticationService!
    fileprivate var dataService: MockDataService!
    private let disposeBag = DisposeBag()
    var sut: ProfileViewModel!
    
    override func setUp() {
        super.setUp()
        self.authService = MockAuthenticationService()
        self.dataService = MockDataService()
        self.sut = ProfileViewModel(authService: self.authService, dataService: self.dataService)
    }

    override func tearDown() {
        self.authService = nil
        self.dataService = nil
        self.sut = nil
        super.tearDown()
    }
    
    func testSaveProfile() {
        //Empty Name
        sut.saveProfile(name: "")
        XCTAssertEqual(sut.errorType, AlertErrorType.nameIsRequired)
        
        //Valid Name
        sut.saveProfile(name: "Ricky")
        XCTAssertEqual(sut.errorType, AlertErrorType.nameIsSaved)
    }
    
    func testLogout() {
        let expect = XCTestExpectation(description: "move to HomeViewController")
        sut.onShowHomeViewController
            .subscribe(onNext: { _ in
                expect.fulfill()
            }).disposed(by: disposeBag)
        sut.logout()
        XCTAssertEqual(sut.errorType, AlertErrorType.logoutSuccess)
        wait(for: [expect], timeout: 1.0)
    }

}
