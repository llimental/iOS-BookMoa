//
//  BestSellerEndPoint.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/18.
//

import Foundation

final class BestSellerEndPoint: RequestableAndResponsable {
    typealias Response = BestSeller

    var methodType: HTTPMethodType
    var scheme: String
    var host: String
    var path: String
    var query: [URLQueryItem]

    init() {
        let api = BookAPI.bestSeller

        self.methodType = .get
        self.scheme = BookAPI.scheme
        self.host = BookAPI.host
        self.path = api.path
        self.query = api.query
    }
}
