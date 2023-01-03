//
//  Films.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 03.01.2023.
//

import Foundation

// MARK: - Films
struct Films: Decodable {
    let all: [Film]
    let total: Int
    let limit: Int
    let page: Int
    let pages: Int
    
    enum CodingKeys: String, CodingKey {
        case all = "docs"
        case total, limit, page, pages
    }
}
