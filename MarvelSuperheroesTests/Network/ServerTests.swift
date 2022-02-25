//
//  ServerTests.swift
//  MarvelSuperheroesTests
//
//  Created by Arturo Murillo on 2/25/22.
//

import XCTest
import RxSwift
import OHHTTPStubs
@testable import MarvelSuperheroes

class ServerTests: XCTestCase {
    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        super.tearDown()
        
        disposeBag = nil
    }

    func testSimpleErrorRequest() {
        NetworkStub.default.defaultStub(urlEndsWith: "v1/public/characters",
                                        jsonMock: "json_mock",
                                        type: ServerTests.self)
        let sut = Networker()
        let exp = expectation(description: "Wait for result")
        let request = MarvelServerRequest(url: URL(string: "https://gateway.marvel.com:443/v1/public/characters")!,
                                          method: .get,
                                          params: ServerRequestParams(params: [:]),
                                          headers: nil)
        
        let requestSingle: Single<ServerResponse<NetworkTestModel>> = sut.single(request: request)
        requestSingle
            .subscribe(onSuccess: { response in
                XCTFail("This flow should never happen as json is invalid")
                exp.fulfill()
            }, onFailure: { error in
                //this call returns an error as the json received is invalid
                exp.fulfill()
            })
            .disposed(by: disposeBag)
        wait(for: [exp], timeout: 5.0)
    }
    
    func testSimpleRequest() {
        NetworkStub.default.defaultStub(urlEndsWith: "v1/public/characters",
                                        jsonMock: "characters",
                                        type: ServerTests.self)
        let sut = Networker()
        let exp = expectation(description: "Wait for result")
        let request = MarvelServerRequest(url: URL(string: "https://gateway.marvel.com:443/v1/public/characters")!,
                                          method: .get,
                                          params: ServerRequestParams(params: [:]),
                                          headers: nil)
        
        let requestSingle: Single<ServerResponse<Character>> = sut.single(request: request)
        
        requestSingle
            .subscribe(onSuccess: { response in
                //this call returns valid response
                exp.fulfill()
            }, onFailure: { error in
                XCTFail("This flow should never return error as JSON is Valid")
                exp.fulfill()
            })
            .disposed(by: disposeBag)
        wait(for: [exp], timeout: 5.0)
    }
}
