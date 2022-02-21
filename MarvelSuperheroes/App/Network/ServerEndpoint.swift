//
//  ServerEndpoint.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/20/22.
//

import Foundation

enum ServerEndpoint {
    case characters
    
    private var baseURL: String {
        return "https://gateway.marvel.com/v1/public"
    }
    
    var url: URL {
        switch self {
        case .characters:
            return URL(staticString: "\(baseURL)/characters")
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
