//
//  CategoryEndPoint.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/30.
//

import Foundation

final class CategoryEndPoint: RequestableAndResponsable {
    typealias Response = Category

    var methodType: HTTPMethodType
    var scheme: String
    var host: String
    var path: String
    var query: [URLQueryItem]

    init(categoryID: String, startIndex: String) {
        let api = BookAPI.category(categoryID: categoryID, startIndex: startIndex)

        self.methodType = .get
        self.scheme = BookAPI.scheme
        self.host = BookAPI.host
        self.path = api.path
        self.query = api.query
    }
}
