//
//  Character.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/20/22.
//

import Foundation

struct Character: Codable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: ImageURL
    let resourceURL: URL?
    let links: [Link]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case thumbnail
        case resourceURL = "resourceURI"
        case links = "urls"
    }
}

struct ImageURL: Codable {
    let path: String
    let fileExtension: String
    
    var url: URL? {
        return URL(string: "\(path).\(fileExtension)")
    }
    
    enum CodingKeys: String, CodingKey {
        case path
        case fileExtension = "extension"
    }
}

enum LinkType: String, Codable {
    case detail
    case wiki
    case comiclink
}

struct Link: Codable {
    var typeString: String
    var url: URL?
    
    var type: LinkType {
        return LinkType(rawValue: typeString) ?? .detail
    }
    
    enum CodingKeys: String, CodingKey {
        case typeString = "type"
        case url
    }
}
