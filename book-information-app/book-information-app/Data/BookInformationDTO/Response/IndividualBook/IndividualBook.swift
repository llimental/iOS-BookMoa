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
        let fullDescription: String
        let fullDescription2: String
        let subInfo: SubInfo
    }

    // MARK: - SubInfo
    struct SubInfo: Decodable {
        let subTitle: String
        let originalTitle: String
        let itemPage: Int
        let toc: String
        let story: String
        let authors: [Author]
    }

    struct Author: Decodable {
        let authorName: String
        let authorInfo: String
    }
}
