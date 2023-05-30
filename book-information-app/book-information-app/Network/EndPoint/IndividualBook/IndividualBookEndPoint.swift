//
//  IndividualBookEndPoint.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/28.
//

import Foundation

final class IndividualBookEndPoint: RequestableAndResponsable {
    typealias Response = IndividualBook

    var methodType: HTTPMethodType
    var scheme: String
    var host: String
    var path: String
    var query: [URLQueryItem]

    init(isbn: String) {
        let api = BookAPI.individualBook(isbn: isbn)

        self.methodType = .get
        self.scheme = BookAPI.scheme
        self.host = BookAPI.host
        self.path = api.path
        self.query = api.query
    }
}
