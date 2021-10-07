//
//  PasswordCredentialsTests.swift
//  PrometheusTests
//
//  Created by Pyretttt on 28.09.2021.
//

import XCTest
@testable import Prometheus

class PasswordCredentialsTests: XCTestCase {

	@PasswordCredential(lenght: 4)
	private var sut: String

	override func tearDown() {
		_sut.emptify()
		super.tearDown()
	}
	
	func testSetPassword() {
		// arrange & act
		sut = "1"
		sut = "2"
		sut = "3"
		sut = "4"
		
		// assert
		XCTAssertEqual($sut, "1234")
	}
	
	func testSetMoreThanOneSymbolAtOnce() {
		// arrange & act
		sut = "1234"
		
		// assert
		XCTAssertEqual($sut, "")
	}
	
	func testClearPassword() {
		// arrange & act
		sut = "1"
		sut = "2"
		sut = "3"
		sut = "4"
		_sut.emptify()
		
		// assert
		XCTAssertEqual($sut, "")
	}
	
	func testRemoveLastSymbol() {
		// arrange & act
		sut = "1"
		sut = "2"
		_sut.deleteLastChar()
		
		// assert
		XCTAssertEqual($sut, "1")
	}
	
}
