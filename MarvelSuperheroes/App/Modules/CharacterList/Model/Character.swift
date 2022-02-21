//
//  Character.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/20/22.
//

import Foundation

struct CharacterList: Codable {
    let copyright: String?
    let items: CollectionContainer<Character>
    
    enum CodingKeys: String, CodingKey {
        case copyright = "attributionText"
        case items = "data"
    }
}

struct CollectionContainer<T: Codable>: Codable {
    let results: [T]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct Character: Codable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: ImageURL
    let resourceURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case thumbnail
        case resourceURL = "resourceURI"
    }
    
//    {
//                    "id": 1010727,
//                    "name": "Spider-dok",
//                    "description": "",
//                    "modified": "1969-12-31T19:00:00-0500",
//                    "thumbnail": {
//                        "path": "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available",
//                        "extension": "jpg"
//                    },
//                    "resourceURI": "http://gateway.marvel.com/v1/public/characters/1010727",
//                    "comics": {
//                        "available": 0,
//                        "collectionURI": "http://gateway.marvel.com/v1/public/characters/1010727/comics",
//                        "items": [],
//                        "returned": 0
//                    },
//                    "series": {
//                        "available": 0,
//                        "collectionURI": "http://gateway.marvel.com/v1/public/characters/1010727/series",
//                        "items": [],
//                        "returned": 0
//                    },
//                    "stories": {
//                        "available": 0,
//                        "collectionURI": "http://gateway.marvel.com/v1/public/characters/1010727/stories",
//                        "items": [],
//                        "returned": 0
//                    },
//                    "events": {
//                        "available": 0,
//                        "collectionURI": "http://gateway.marvel.com/v1/public/characters/1010727/events",
//                        "items": [],
//                        "returned": 0
//                    },
//                    "urls": [
//                        {
//                            "type": "detail",
//                            "url": "http://marvel.com/characters/2170/spider-dok?utm_campaign=apiRef&utm_source=9eeaa3aaf38cabfba481648bd647bc22"
//                        },
//                        {
//                            "type": "comiclink",
//                            "url": "http://marvel.com/comics/characters/1010727/spider-dok?utm_campaign=apiRef&utm_source=9eeaa3aaf38cabfba481648bd647bc22"
//                        }
//                    ]
//                }
}

struct ImageURL: Codable {
    let path: URL?
    let fileExtension: String
    
    enum CodingKeys: String, CodingKey {
        case path
        case fileExtension = "extension"
    }
}
