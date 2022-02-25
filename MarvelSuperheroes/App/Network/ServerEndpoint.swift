//
//  ServerEndpoint.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/20/22.
//

import Foundation

enum ServerEndpoint {
    case characters
    case comics(characterId: String)
    
    private var baseURL: String {
        return "https://gateway.marvel.com/v1/public"
    }
    
    var url: URL {
        switch self {
        case .characters:
            return URL(staticString: "\(baseURL)/characters")
        case .comics(let characterId):
            return URL(staticString: "\(baseURL)/characters/\(characterId)/comics")
        }
    }
}

extension URL {
    init(staticString string: String) {
        guard let url = URL(string: string) else {
            preconditionFailure("Invalid static URL string: \(string)")
        }
        self = url
    }
}
