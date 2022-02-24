//
//  CharacterServer.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/20/22.
//

import RxSwift

protocol CharacterServer {
    var canLoadMore: Bool { get }
    func getCharacters(withQuery query: String) -> Single<CharacterList>
}

extension CharacterServer {
    func getCharacters() -> Single<CharacterList> {
        return getCharacters(withQuery: "")
    }
}

final class CharacterNetworker: CharacterServer {
    private var offset: Int = 0
    private let limit: Int = 40
    private let server: Server
    private(set) var canLoadMore: Bool = true
    
    init(server: Server = Networker()) {
        self.server = server
    }
    
    func getCharacters(withQuery query: String = "") -> Single<CharacterList> {
        guard canLoadMore else {
            return .just(CharacterList(copyright: nil, items: CollectionContainer<Character>(results: [])))
        }
        let endpoint = ServerEndpoint.characters
        var parameters: [String: Any] = ["orderBy": "name", "offset": offset, "limit": limit]
        if !query.isEmpty {
            parameters["nameStartsWith"] = query
        }
        let params = ServerRequestParams(params: parameters)
        let request = MarvelServerRequest(url: endpoint.url, method: .get, params: params, headers: nil)
        return server.single(request: request)
            .do(onSuccess: { [weak self] data in
                guard let self = self else { return }
                let newItemsCount = data.items.results.count
                self.offset += newItemsCount
                self.canLoadMore = newItemsCount == self.limit
            })
    }
}


