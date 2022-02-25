//
//  NetworkTestModel.swift
//  MarvelSuperheroesTests
//
//  Created by Arturo Murillo on 2/25/22.
//

import Foundation

struct NetworkTestModel: Codable {
    var title: String
    
    enum CodingKeys: String, CodingKey {
        case title
    }
}
