//
//  BestSeller.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/17.
//

import Foundation

// MARK: - BestSeller
struct BestSeller: Codable {
    let publishDate: String
    let item: [Item]

    enum CodingKeys: String, CodingKey {
        case publishDate = "pubDate"
        case item
    }
}
