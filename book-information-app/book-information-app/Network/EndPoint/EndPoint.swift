//
//  EndPoint.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/18.
//

import Foundation

final class EndPoint<R>: Responsable {
    typealias Response = R

    var methodType: HTTPMethodType
    var baseURL: String
    var requestType: String
    var keyParameter: String
    var keyValue: String
    var requiredParameter: String
    var requiredValue: String
    var firstCommonParameter: String?
    var secondCommonParameter: String?

    init(methodType: HTTPMethodType,
         baseURL: String,
         requestType: String,
         keyParameter: String,
         keyValue: String,
         requiredParameter: String,
         requiredValue: String,
         firstCommonParameter: String? = nil,
         secondCommonParameter: String? = nil) {
        self.methodType = methodType
        self.baseURL = baseURL
        self.requestType = requestType
        self.keyParameter = keyParameter
        self.keyValue = keyValue
        self.requiredParameter = requiredParameter
        self.requiredValue = requiredValue
        self.firstCommonParameter = firstCommonParameter
        self.secondCommonParameter = secondCommonParameter
    }
}
