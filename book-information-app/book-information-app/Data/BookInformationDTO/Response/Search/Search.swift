//
//  Search.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/06/01.
//

import Foundation

// MARK: - Search
struct Search: Decodable {
    let totalResults: Int
    let startIndex: Int
    let itemsPerPage: Int
    let query: String
    let item: [Item]

    // MARK: - Item
    struct Item: Decodable {
        let title: String
        let author: String
        let isbn13: String
        let cover: String
    }
}
