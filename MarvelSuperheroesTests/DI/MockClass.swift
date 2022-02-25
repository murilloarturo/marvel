//
//  MockClass.swift
//  MarvelSuperheroesTests
//
//  Created by Arturo Murillo on 2/25/22.
//

import Foundation
@testable import MarvelSuperheroes

final class Mock: NSObject {    
    var helloWorld = "Hello Tests!!"
}

final class MockPropertyWrapper: NSObject {
    @Dependency
    var propertyWrapper: Mock?
}
