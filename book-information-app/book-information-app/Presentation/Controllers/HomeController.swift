//
//  HomeController.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/21.
//

import UIKit

final class HomeController {
    struct Book: Hashable {
        let title: String
        let author: String
        let cover: UIImage

        func hash(into hasher: inout Hasher) {
            hasher.combine(title)
            hasher.combine(author)
        }

        static func == (lhs: HomeController.Book, rhs: HomeController.Book) -> Bool {
            return lhs.title == rhs.title && lhs.author == rhs.author
        }
    }

    struct BestSeller: Hashable {
        let section: String
        let books: [Book]?

        func hash(into hasher: inout Hasher) {
            hasher.combine(section)
        }

        static func == (lhs: HomeController.BestSeller, rhs: HomeController.BestSeller) -> Bool {
            return lhs.section == rhs.section
        }
    }
}
