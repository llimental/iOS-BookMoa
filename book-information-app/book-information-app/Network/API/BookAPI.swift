//
//  BookAPI.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/21.
//

import Foundation

enum BookAPI {
    case bestSeller

    static var scheme: String {
        return "https"
    }

    static var host: String {
        return "www.aladin.co.kr"
    }

    var path: String {
        switch self {
        case .bestSeller:
            return "/ttb/api/ItemList.aspx"
        }
    }

    var query: [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        let keyParameter = URLQueryItem(name: "ttbkey", value: "")
        let outputParameter = URLQueryItem(name: "output", value: "js")
        let apiVersionParameter = URLQueryItem(name: "Version", value: "20131101")

        switch self {
        case .bestSeller:
            let queryTypeParameter = URLQueryItem(name: "QueryType", value: "bestseller")
            let searchTargetParameter = URLQueryItem(name: "SearchTarget", value: "book")
            queryItems = [keyParameter, outputParameter, apiVersionParameter, queryTypeParameter, searchTargetParameter]
        }

        return queryItems
    }
}
