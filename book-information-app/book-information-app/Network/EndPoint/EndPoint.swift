//
//  EndPoint.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/18.
//

import Foundation

final class EndPoint<R>: Requestable, Responsable {
    typealias Response = R

    var methodType: HTTPMethodType
    var baseURL: String
    var requestType: String
    var keyParameter: String
    var requiredParameter: String
    var output: String
    var apiVersion: String

    init(methodType: HTTPMethodType,
         baseURL: String,
         requestType: String,
         keyParameter: String,
         requiredParameter: String,
         output: String,
         apiVersion: String) {
        self.methodType = methodType
        self.baseURL = baseURL
        self.requestType = requestType
        self.keyParameter = keyParameter
        self.requiredParameter = requiredParameter
        self.output = output
        self.apiVersion = apiVersion
    }
}
