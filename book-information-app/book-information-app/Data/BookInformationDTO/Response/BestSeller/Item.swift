//
//  Item.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/17.
//

import Foundation

// MARK: - Item
struct Item: Codable {
    let title: String
    let link: String
    let author: String
    let pubDate: String
    let description: String
    let isbn: String
    let isbn13: String
    let priceSales: Int
    let priceStandard: Int
    let stockStatus: String
    let cover: String
    let categoryID: Int
    let categoryName: String
    let publisher: String
    let adult: Bool
    let fixedPrice: Bool
    let customerReviewRank: Int
    let bestRank: Int
    let bestDuration: String?
    let seriesInfo: SeriesInfo?

    enum CodingKeys: String, CodingKey {
        case title
        case link
        case author
        case pubDate
        case description
        case isbn
        case isbn13
        case priceSales
        case priceStandard
        case stockStatus
        case cover
        case categoryID = "categoryId"
        case categoryName
        case publisher
        case adult
        case fixedPrice
        case customerReviewRank
        case bestRank
        case bestDuration
        case seriesInfo
    }
}

// MARK: - SeriesInfo
struct SeriesInfo: Codable {
    let seriesName: String
}
