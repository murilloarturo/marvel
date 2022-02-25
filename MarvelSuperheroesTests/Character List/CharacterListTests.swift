//
//  CharacterListTests.swift
//  MarvelSuperheroesTests
//
//  Created by Arturo Murillo on 2/25/22.
//

import XCTest
import RxSwift
import RxBlocking
@testable import MarvelSuperheroes

class CharacterListTests: XCTestCase {
    private var disposeBag: DisposeBag!
    var sut: CharacterListFlowInteractor!

    override func setUp() {
        super.setUp()
        
        disposeBag = DisposeBag()
        DependencyContainer.registerBuilder(for: EndpointRequester.self) {
            let mock = EndpointNetworkerMock()
            return mock
        }
        sut = CharacterListFlowInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
        
        disposeBag = nil
    }
    
    func testInteractor() {
        let mock = EndpointNetworkerMock()
        mock.items = [Character(id: 0, name: "", description: "", thumbnail: ImageURL(path: "", fileExtension: ""), resourceURL: nil, links: []), Character(id: 0, name: "", description: "", thumbnail: ImageURL(path: "", fileExtension: ""), resourceURL: nil, links: [])]
        DependencyContainer.registerBuilder(for: EndpointRequester.self) {
            return mock
        }
        sut = CharacterListFlowInteractor()
        XCTAssertTrue(sut.canLoadMore)
        let data = sut.dataStream.toBlocking(timeout: 5)
        let items = try? data.first()?.items
        XCTAssertEqual(items?.count, 2)
        mock.canLoadMore = false
        XCTAssertFalse(sut.canLoadMore)
        
        mock.canLoadMore = true
        mock.items = []
        sut.search("HELLO")
        let searchData = sut.dataStream.toBlocking(timeout: 5)
        let newItems = try? searchData.first()?.items
        XCTAssertEqual(newItems?.count, 0)
    }

}
