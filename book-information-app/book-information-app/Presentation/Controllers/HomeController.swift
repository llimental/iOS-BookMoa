//
//  HomeController.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/21.
//

import Foundation

final class HomeController {
    struct Book: Hashable {
        let title: String
        let author: String
        let identifier = UUID()

        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }

    struct BestSeller: Hashable {
        let title: String
        let books: [Book]?
        let identifier = UUID()

        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }
}
