//
//  CategoryController.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/31.
//

import UIKit

final class CategoryController {
    enum Section: String, CaseIterable {
        case categoryBookList
    }

    struct CategoryBook: Hashable {
        let title: String
        let author: String
        let cover: UIImage
        let isbn: String

        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }

        static func == (lhs: CategoryController.CategoryBook, rhs: CategoryController.CategoryBook) -> Bool {
            return lhs.identifier == rhs.identifier
        }

        private let identifier = UUID()
    }
}
