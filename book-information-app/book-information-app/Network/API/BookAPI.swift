//
//  BookAPI.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/21.
//

import Foundation

enum BookAPI {
    case bestSeller
    case individualBook(isbn: String)
    case category(categoryId: String)

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

        case .individualBook:
            return "/ttb/api/ItemLookUp.aspx"

        case .category:
            return "/ttb/api/ItemList.aspx"
        }
    }

    var query: [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        let keyParameter = URLQueryItem(name: "ttbkey", value: getAPIKey())
        let outputParameter = URLQueryItem(name: "output", value: "js")
        let apiVersionParameter = URLQueryItem(name: "Version", value: "20131101")

        switch self {
        case .bestSeller:
            let queryTypeParameter = URLQueryItem(name: "QueryType", value: "bestseller")
            let searchTargetParameter = URLQueryItem(name: "SearchTarget", value: "book")

            queryItems = [keyParameter, outputParameter, apiVersionParameter, queryTypeParameter, searchTargetParameter]

        case .individualBook(let isbn):
            let itemIdTypeParameter = URLQueryItem(name: "itemIdType", value: "ISBN")
            let itemIdParameter = URLQueryItem(name: "ItemId", value: isbn)
            let optionResultParameter = URLQueryItem(name: "OptResult", value: "authors,fulldescription,Toc,Story,previewImgList")
            let coverParameter = URLQueryItem(name: "cover", value: "big")

            queryItems = [keyParameter, outputParameter, apiVersionParameter, itemIdTypeParameter, itemIdParameter, optionResultParameter, coverParameter]

        case .category(let categoryId):
            let queryTypeParameter = URLQueryItem(name: "QueryType", value: "ItemNewAll")
            let categoryIdParameter = URLQueryItem(name: "CategoryId", value: categoryId)

            queryItems = [keyParameter, outputParameter, apiVersionParameter, queryTypeParameter, categoryIdParameter]
        }

        return queryItems
    }

    private func getAPIKey() -> String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "BookAPIKey") as? String else { return "" }

        return apiKey
    }
}
