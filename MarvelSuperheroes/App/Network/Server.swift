//
//  Networker.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/20/22.
//

import Alamofire
import RxSwift

protocol Server {
    func single<Object: Codable>(request: ServerRequest) -> Single<Object>
}

final class Networker: Server {
    func single<Object: Codable>(request: ServerRequest) -> Single<Object> {
        return .create { single in
            AF.request(request.url,
                       method: request.method,
                       parameters: request.params.build(),
                       headers: request.headers)
                .validate()
                .responseDecodable(of: Object.self) { response in
                    switch response.result {
                    case .success(let object):
                        single(.success(object))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
        
            return Disposables.create()
        }
        .observe(on: MainScheduler.instance)
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
}
