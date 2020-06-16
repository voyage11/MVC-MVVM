//
//  LoginViewModelTests.swift
//  mvc-mvvmTests
//
//  Created by Ricky on 15/6/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import XCTest
@testable import mvc_mvvm

class LoginViewModelTests: XCTestCase {

    fileprivate var authService: MockAuthenticationService!
    var sut: LoginViewModel!
    
    override func setUp() {
        super.setUp()
        self.authService = MockAuthenticationService()
        self.sut = LoginViewModel(authService: self.authService)
    }

    override func tearDown() {
        self.authService = nil
        self.sut = nil
        super.tearDown()
    }
    
    func testLogin() {
        //Email Not Entered
        sut.login()
        XCTAssertEqual(sut.errorType, AlertErrorType.emailRequired)
        
        //Password Not Entered
        sut.email.accept("a@a.com")
        sut.login()
        XCTAssertEqual(sut.errorType, AlertErrorType.passwordRequired)

        //Invalid Email/Password
        sut.password.accept("aaa")
        sut.login()
        XCTAssertEqual(sut.errorType, AlertErrorType.error(APIError.invalidEmailOrPassword.localizedDescription))

        //Valid Email and Password
        sut.password.accept("abcd1234")
        sut.login()
        XCTAssertEqual(sut.errorType, AlertErrorType.loginSuccess)
    }
    
}

