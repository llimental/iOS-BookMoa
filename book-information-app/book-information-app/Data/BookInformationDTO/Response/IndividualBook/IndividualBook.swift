//
//  IndividualBook.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/28.
//

import Foundation

// MARK: - IndividualBook
struct IndividualBook: Decodable {
    let item: [Item]

    // MARK: - Item
    struct Item: Decodable {
        let title: String
        let link: String
        let author: String
        let pubDate: String
        let description: String
        let cover: String
        let categoryName: String
        let publisher: String
        let subInfo: SubInfo

        enum CodingKeys: String, CodingKey {
            case title
            case link
            case author
            case pubDate
            case description
            case cover
            case categoryName
            case publisher
            case subInfo
        }
    }

    // MARK: - SubInfo
    struct SubInfo: Decodable {
        let subTitle, originalTitle: String
        let itemPage: Int
    }
}
