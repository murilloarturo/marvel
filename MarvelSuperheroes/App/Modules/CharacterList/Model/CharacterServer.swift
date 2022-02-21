//
//  CharacterServer.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/20/22.
//

import RxSwift

protocol CharacterServer {
    func getCharacters(offset: Int, limit: Int) -> Single<CharacterList>
}

final class CharacterNetworker: CharacterServer {
    private let server: Server
    
    init(server: Server = Networker()) {
        self.server = server
    }
    
    func getCharacters(offset: Int, limit: Int) -> Single<CharacterList> {
        let endpoint = ServerEndpoint.characters
        let params = ServerRequestParams(params: ["offset": offset, "limit": limit])
        let request = MarvelServerRequest(url: endpoint.url, method: .get, params: params, headers: nil)
        return server.single(request: request)
    }
}


