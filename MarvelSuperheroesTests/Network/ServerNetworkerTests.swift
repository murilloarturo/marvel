//
//  ServerNetworkerTests.swift
//  MarvelSuperheroesTests
//
//  Created by Arturo Murillo on 2/25/22.
//

import XCTest
import RxSwift
import OHHTTPStubs
@testable import MarvelSuperheroes

class ServerNetworkerTests: XCTestCase {
    private var disposeBag: DisposeBag!
    private var sut: EndpointNetWorker!

    override func setUp() {
        super.setUp()
        
        sut = EndpointNetWorker()
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
        disposeBag = nil
    }

    func testRequest() {
        NetworkStub.default.defaultStub(urlEndsWith: "v1/public/characters",
                                        jsonMock: "characters",
                                        type: ServerTests.self)
        let exp = expectation(description: "Wait for result")
        XCTAssertEqual(sut.offset, 0)
        XCTAssertEqual(sut.limit, 40)
        sut.fetchData(Character.self, endpoint: ServerEndpoint.characters, params: [:])
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else {
                    exp.fulfill()
                    return
                }
                XCTAssertTrue(self.sut.canLoadMore)
                XCTAssertEqual(self.sut.limit, 40)
                exp.fulfill()
            })
            .disposed(by: disposeBag)
        wait(for: [exp], timeout: 5.0)
    }
}
