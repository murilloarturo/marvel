//
//  ServerNetworker.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/24/22.
//

import RxSwift

protocol EndpointRequester {
    var canLoadMore: Bool { get }
    func fetchData<T: Codable>(_ object: T.Type, endpoint: ServerEndpoint, params: [String: Any]) -> Single<ServerResponse<T>>
}

final class EndpointNetWorker: EndpointRequester {
    private var offset: Int = 0
    private let limit: Int = 40
    private(set) var canLoadMore: Bool = true
    @Dependency var server: Server?
      
    func fetchData<T>(_ object: T.Type, endpoint: ServerEndpoint, params: [String : Any]) -> Single<ServerResponse<T>> where T : Decodable, T : Encodable {
        guard let server = server, canLoadMore else {
            return .just(ServerResponse<T>())
        }
        var params = ServerRequestParams(params: params)
        params.additionalParams["offset"] = offset
        params.additionalParams["limit"] = limit
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
