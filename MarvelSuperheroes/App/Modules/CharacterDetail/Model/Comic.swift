//
//  Comic.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/24/22.
//

import Foundation

final class Comic: Codable {
    var id: Int
    var title: String
    var issueNumber: Int
    var links: [Link]
    var image: ImageURL
    
    var detail: URL? {
        return links.first(where: { $0.type == .detail })?.url
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case issueNumber
        case links = "urls"
        case image = "thumbnail"
    }
}
