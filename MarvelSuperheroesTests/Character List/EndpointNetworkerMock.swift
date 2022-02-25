//
//  EndpointNetworkerMock.swift
//  MarvelSuperheroesTests
//
//  Created by Arturo Murillo on 2/25/22.
//

import Foundation
import RxSwift
@testable import MarvelSuperheroes
 
final class EndpointNetworkerMock: EndpointRequester {
    var items: [Any] = []
    var canLoadMore: Bool = true
    
    func fetchData<T: Codable>(_ object: T.Type, endpoint: ServerEndpoint, params: [String : Any]) -> Single<ServerResponse<T>> {
        var response = ServerResponse<T>()
        for item in items {
            guard let object = item as? T else { continue }
            response.items.results.append(object)
        }
        return .just(response)
    }
}
