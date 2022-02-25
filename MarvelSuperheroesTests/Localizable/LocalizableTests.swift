//
//  LocalizableTests.swift
//  MarvelSuperheroesTests
//
//  Created by Arturo Murillo on 2/25/22.
//

import XCTest
@testable import MarvelSuperheroes

class LocalizableTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLocalizablesEN() {
        //Common
        XCTAssertEqual(LocalizableString.error.localized, "Oops!!")
        XCTAssertEqual(LocalizableString.ok.localized, "ok")
        //Home
        XCTAssertEqual(LocalizableString.abc.localized, "ABC")
        XCTAssertEqual(LocalizableString.superheroes.localized, "Superheroes")
        XCTAssertEqual(LocalizableString.noHeroesFound.localized, "No heroes found")
        //Detail
        XCTAssertEqual(LocalizableString.issue.localized, "Issue Number: ")
        XCTAssertEqual(LocalizableString.comics.localized, "Comics")
        XCTAssertEqual(LocalizableString.comicsLink.localized, "Looking for other comics of %@?")
        XCTAssertEqual(LocalizableString.comicsLink.localized(with: ["Arturo"]), "Looking for other comics of Arturo?")
        XCTAssertEqual(LocalizableString.detailLink.localized, "Want to know more about %@?")
        XCTAssertEqual(LocalizableString.detailLink.localized(with: ["Arturo"]), "Want to know more about Arturo?")
        XCTAssertEqual(LocalizableString.wikiLink.localized, "Check out the wiki page of %@")
        XCTAssertEqual(LocalizableString.wikiLink.localized(with: ["Arturo"]), "Check out the wiki page of Arturo")
    }

}
