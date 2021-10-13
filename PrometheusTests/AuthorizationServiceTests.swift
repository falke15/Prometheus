//
//  AuthorizationServiceTests.swift
//  PrometheusTests
//
//  Created by Pyretttt on 20.09.2021.
//

import XCTest
@testable import Prometheus

class AuthorizationServiceTests: XCTestCase {

	private var sut: AuthorizationService!
	
    override func setUp() {
		super.setUp()
        sut = AuthorizationService()
    }

    override func tearDown() {
        sut = nil
		super.tearDown()
    }
	
	func testSetupPassword() throws {
		// arrange
		let pass = "1234"
		
		// act && assert
		XCTAssertNoThrow(try sut.setPassword(password: pass))
		XCTAssertTrue(sut.isRegistered)
		XCTAssertNoThrow(try sut.signIn(with: pass))
		XCTAssertEqual(try sut.signIn(with: pass), true)
	}
	
	func testUpdatePassword() throws {
		// arrange
		let pass = "1234"
		let newPass = "2345"
		
		// act && assert
		XCTAssertNoThrow(try sut.setPassword(password: pass))
		XCTAssertTrue(sut.isRegistered)
		XCTAssertFalse(try sut.signIn(with: newPass))
		XCTAssertNoThrow(try sut.setPassword(password: newPass))
		XCTAssertFalse(try sut.signIn(with: pass))
		XCTAssertTrue(try sut.signIn(with: newPass))
	}
}
