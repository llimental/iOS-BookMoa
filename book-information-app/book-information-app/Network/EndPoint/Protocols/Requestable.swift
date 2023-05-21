//
//  Requestable.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/18.
//

import Foundation

protocol Requestable {

    // MARK: - Public Properties

    var methodType: HTTPMethodType { get }
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var query: [URLQueryItem] { get }
}

extension Requestable {

    // MARK: - Public Functions

    func makeURLRequest() throws -> URLRequest {
        guard let url = urlComponent else {
            throw URLComponentsError.invalidComponent
        }

        var request = URLRequest(url: url)
        request.httpMethod = methodType.rawValue

        return request
    }

    // MARK: - Private Properties

    private var urlComponent: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = query

        return components.url
    }
}
