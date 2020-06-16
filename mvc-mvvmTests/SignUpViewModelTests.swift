//
//  SignUpViewModelTests.swift
//  mvc-mvvmTests
//
//  Created by Ricky on 16/6/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import XCTest
@testable import mvc_mvvm

class SignUpViewModelTests: XCTestCase {

    fileprivate var authService: MockAuthenticationService!
    var sut: SignUpViewModel!
    
    override func setUp() {
        super.setUp()
        self.authService = MockAuthenticationService()
        self.sut = SignUpViewModel(authService: self.authService)
    }

    override func tearDown() {
        self.authService = nil
        self.sut = nil
        super.tearDown()
    }
    
    func testSignUp() {
        //Email Not Entered
        sut.signUp()
        XCTAssertEqual(sut.errorType, AlertErrorType.emailRequired)
        
        //Password Not Entered
        sut.email.accept("a@a.com")
        sut.signUp()
        XCTAssertEqual(sut.errorType, AlertErrorType.passwordRequired)

        //Email with Existing Account
        sut.password.accept("abcd1234")
        sut.signUp()
        XCTAssertEqual(sut.errorType, AlertErrorType.error(APIError.emailAlreadyInUse.localizedDescription))
        
        //New Email and Password
        sut.email.accept("b@b.com")
        sut.signUp()
        XCTAssertEqual(sut.errorType, AlertErrorType.signUpSuccess)
    }
    
}
