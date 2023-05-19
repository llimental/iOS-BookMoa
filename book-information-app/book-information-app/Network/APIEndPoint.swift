//
//  APIEndPoint.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/19.
//

import Foundation

struct APIEndPoint {
    static func receiveBestSeller() -> EndPoint<BestSeller> {
        return EndPoint(methodType: .get,
                        baseURL: Basic.baseURL,
                        requestType: ItemList.requestType,
                        keyParameter: Basic.keyParameter,
                        requiredParameter: ItemList.queryType,
                        output: Basic.output,
                        apiVersion: Basic.apiVersion)
    }
}
