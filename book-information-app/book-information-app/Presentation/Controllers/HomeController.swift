//
//  HomeController.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/21.
//

import UIKit

final class HomeController {
    struct Book: Hashable {
        let identifier = UUID()
        let title: String
        let author: String
        let cover: UIImage

        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }

        static func == (lhs: HomeController.Book, rhs: HomeController.Book) -> Bool {
            return lhs.identifier == rhs.identifier
        }
    }

    struct BestSeller: Hashable {
        let identifier = UUID()
        let section: String
        let books: [Book]?

        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }

        static func == (lhs: HomeController.BestSeller, rhs: HomeController.BestSeller) -> Bool {
            return lhs.identifier == rhs.identifier
        }
    }
}
