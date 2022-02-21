//
//  ServerRequest.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/20/22.
//

import Alamofire
import CryptoKit

enum ServerKeys: String {
    case `private`
    case `public`
    
    static var dictionaryName: String = "API"

    func get(from dictionary: [String: Any]) -> String? {
        guard let apiKeys = dictionary[ServerKeys.dictionaryName] as? [String: Any],
                let value = apiKeys[rawValue] as? String else {
                    return nil
                }
        return value
    }
}

struct ServerRequestParams {
    private let additionalParams: [String: Any]
    
    init(params: [String: Any]) {
        self.additionalParams = params
    }
    
    func build(using dictionary: [String: Any] = Bundle.getInfoPlist()) -> [String: Any] {
        var params: [String: Any] = additionalParams
        let time: String = "\(Date().timeIntervalSince1970)"
        let privateKey = ServerKeys.private.get(from: dictionary) ?? ""
        let publicKey = ServerKeys.public.get(from: dictionary) ?? ""
        params["apikey"] = publicKey
        params["ts"] = time
        params["hash"] = "\(time)\(privateKey)\(publicKey)".generateMD5()
        
        return params
    }
}

protocol ServerRequest {
    var url: URL { get }
    var method: HTTPMethod { get }
    var params: ServerRequestParams { get }
    var headers: HTTPHeaders? { get }
}

struct MarvelServerRequest: ServerRequest {
    let url: URL
    let method: HTTPMethod
    let params: ServerRequestParams
    let headers: HTTPHeaders?
}

extension Bundle {
    static func getInfoPlist() -> [String: Any] {
        return Bundle.main.infoDictionary ?? [:]
    }
}

extension String {
    func generateMD5() -> String {
        guard let data = self.data(using: .utf8) else { return "" }
        let computed = Insecure.MD5.hash(data: data)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}
