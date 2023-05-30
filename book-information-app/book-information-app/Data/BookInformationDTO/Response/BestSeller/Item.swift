//
//  Item.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/17.
//

import Foundation

// MARK: - Item
struct Item: Decodable {
    let title: String
    let author: String
    let isbn13: String
    let cover: String
}
