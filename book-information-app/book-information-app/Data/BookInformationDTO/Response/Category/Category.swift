//
//  Category.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/30.
//

import Foundation

// MARK: - Category
struct Category: Decodable {
    let totalResults: Int
    let startIndex: Int
    let itemsPerPage: Int
    let searchCategoryName: String
    let item: [Item]

    // MARK: - Item
    struct Item: Decodable {
        let title: String
        let author: String
        let isbn13: String
        let cover: String
    }
}
