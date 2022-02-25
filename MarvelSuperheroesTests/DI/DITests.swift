//
//  DITests.swift
//  MarvelSuperheroesTests
//
//  Created by Arturo Murillo on 2/25/22.
//

import XCTest
@testable import MarvelSuperheroes

class DITests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        
        DependencyContainer.clear()
    }

    func testRegister() {
        let test = Mock()
        DependencyContainer.register(test)
        let dependency: Mock? = DependencyContainer.resolve()
        XCTAssertNotNil(dependency)
        XCTAssertEqual(dependency, test)
    }
    
    func testRegisterBuilder() {
        DependencyContainer.registerBuilder(for: Mock.self) {
            return Mock()
        }
        let dependency: Mock? = DependencyContainer.resolve()
        XCTAssertNotNil(dependency)
    }
    
    func testPropertyWrapper() {
        let test = Mock()
        DependencyContainer.register(test)
        let mock = MockPropertyWrapper()
        XCTAssertNotNil(mock.propertyWrapper)
        XCTAssertEqual(mock.propertyWrapper, test)
    }
}
