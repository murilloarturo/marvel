//
//  ServerResponse.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/24/22.
//

import Foundation

struct ServerResponse<T: Codable>: Codable {
    var code: Int
    var copyright: String?
    var items: CollectionContainer<T>
    
    enum CodingKeys: String, CodingKey {
        case code
        case copyright = "attributionText"
        case items = "data"
    }
    
    init() {
        code = 0
        copyright = nil
        items = CollectionContainer<T>()
    }
}

struct CollectionContainer<T: Codable>: Codable {
    var results: [T]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    init() {
        results = []
    }
    
    mutating func append(collection: CollectionContainer<T>) {
        results.append(contentsOf: collection.results)
    }
}
