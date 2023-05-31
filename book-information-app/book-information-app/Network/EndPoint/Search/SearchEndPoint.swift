//
//  SearchEndPoint.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/06/01.
//

import Foundation

final class SearchEndPoint: RequestableAndResponsable {
    typealias Response = Search

    var methodType: HTTPMethodType
    var scheme: String
    var host: String
    var path: String
    var query: [URLQueryItem]

    init(queryString: String, startIndex: String) {
        let api = BookAPI.search(query: queryString, startIndex: startIndex)

        self.methodType = .get
        self.scheme = BookAPI.scheme
        self.host = BookAPI.host
        self.path = api.path
        self.query = api.query
    }
}
