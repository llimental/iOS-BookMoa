//
//  Requestable.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/18.
//

import Foundation

protocol Requestable {
    var methodType: HTTPMethodType { get }
    var baseURL: String { get }
    var requestType: String { get }
    var keyParameter: String { get }
    var requiredParameter: String { get }
    var output: String { get }
    var apiVersion: String { get }
}

extension Requestable {

    // MARK: - Public Functions

    func receiveURLRequest() throws -> URLRequest {
        let url = try receiveURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethodType.get.rawValue

        return urlRequest
    }
    
    // MARK: - Private Functions

    private func receiveURL() throws -> URL {
        let originalURL = "\(baseURL)\(requestType)"

        guard var components = URLComponents(string: originalURL) else {
            throw URLComponentsError.invalidComponent
        }

        let keyQuery = URLQueryItem(name: keyParameter, value: Basic.key)
        let requiredQuery = URLQueryItem(name: requiredParameter, value: QueryType.bestSeller.rawValue)
        let outputQuery = URLQueryItem(name: output, value: OutputType.json.rawValue)
        let versionQuery = URLQueryItem(name: apiVersion, value: APIVersion.versionNumber.rawValue)

        components.queryItems = [keyQuery, requiredQuery, outputQuery, versionQuery]

        guard let changedURL = components.url else {
            throw URLComponentsError.invalidComponent
        }

        return changedURL
    }
}
