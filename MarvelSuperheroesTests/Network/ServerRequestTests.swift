//
//  ServerRequestTests.swift
//  MarvelSuperheroesTests
//
//  Created by Arturo Murillo on 2/25/22.
//

import XCTest
@testable import MarvelSuperheroes

class ServerRequestTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testMissingAPIKey() {
        let plist: [String: Any] = [:]
        let additionalParameters: [String: Any] = [:]
        let parameters = ServerRequestParams(params: additionalParameters)
        let buildParameters = parameters.build(using: plist)
        XCTAssertNil(buildParameters["apikey"])
        XCTAssertNil(buildParameters["ts"])
        XCTAssertNil(buildParameters["hash"])
    }
    
    func testAPIKey() {
        let plist: [String: Any] = ["API": ["public": "abc", "private": "def"]]
        let additionalParameters: [String: Any] = [:]
        let parameters = ServerRequestParams(params: additionalParameters)
        let buildParameters = parameters.build(using: plist)
        XCTAssertNotNil(buildParameters["apikey"])
        XCTAssertEqual(buildParameters["apikey"] as? String, "abc")
        XCTAssertNotNil(buildParameters["ts"])
        XCTAssertNotNil(buildParameters["hash"])
    }
    
    func testEndpoint() {
        let characters = ServerEndpoint.characters
        XCTAssertEqual(characters.url.absoluteString, "https://gateway.marvel.com/v1/public/characters")
        let comics = ServerEndpoint.comics(characterId: "123")
        XCTAssertEqual(comics.url.absoluteString, "https://gateway.marvel.com/v1/public/characters/123/comics")
    }
    
    func testServerResponse() {
        let json = JSONReaderUtils.readDictionaryJson(fileName: "characters")
        if let json = json, let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            let decoder = JSONDecoder()
            let object = try? decoder.decode(ServerResponse<Character>.self, from: data)
            XCTAssertNotNil(object)
            XCTAssertEqual(object?.copyright, "Data provided by Marvel. © 2022 MARVEL")
            XCTAssertEqual(object?.items.results.count, 20)
            validateCharacter(object?.items.results[0])
        } else {
            XCTFail("mapping should not fail")
        }
    }
    
    func validateCharacter(_ character: Character!) {
        XCTAssertEqual(character.name, "Iceman")
        XCTAssertEqual(character.description, "")
        XCTAssertEqual(character.id, 1009362)
        XCTAssertNotNil(character.resourceURL)
        XCTAssertNotNil(character.thumbnail.url)
    }
}
