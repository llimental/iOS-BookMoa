//
//  HomeController.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/21.
//

import UIKit

final class HomeController {
    enum Section: String, CaseIterable {
        case bestSeller = "지금 가장 인기있는 도서"
        case category = "장르별 찾기"
    }

    struct Book: Hashable {
        let title: String
        let author: String
        let cover: UIImage

        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }

        static func == (lhs: HomeController.Book, rhs: HomeController.Book) -> Bool {
            return lhs.identifier == rhs.identifier
        }

        private let identifier = UUID()
    }

    struct Category: Hashable {
        let title: String

        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }

        static func == (lhs: Category, rhs: Category) -> Bool {
            return lhs.identifier == rhs.identifier
        }

        private let identifier = UUID()
    }
}
