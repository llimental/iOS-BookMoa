//
//  NetworkService.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/18.
//

import UIKit

final class NetworkService {

    // MARK: - Initialization
    
    init() {
        session = URLSession(configuration: .default)
    }
    
    // MARK: - Private Functions
    
    func requestData<D: Decodable, R: RequestableAndResponsable>(with endPoint: R) async throws -> D where R.Response == D {
        let urlRequest = try endPoint.makeURLRequest()

        let (data, response) = try await session.data(for: urlRequest)

        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            try verifyResponse(with: httpResponse)
        }

        let decodedData: D = try decodeData(with: data)

        return decodedData
    }

    func requestBestSellerImage(with items: [Item]) async throws -> [UIImage] {
        var imageSet: [UIImage] = []

        for item in items{
            guard let url = URL(string: item.cover) else {
                throw URLComponentsError.invalidComponent
            }

            let urlRequest = URLRequest(url: url)

            let (data, response) = try await session.data(for: urlRequest)

            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                try verifyResponse(with: httpResponse)
            }

            imageSet.append(UIImage(data: data) ?? UIImage())
        }

        return imageSet
    }

    func requestIndividualBookImage(with item: IndividualBook.Item) async throws -> UIImage {
        guard let url = URL(string: item.cover) else {
            throw URLComponentsError.invalidComponent
        }

        let urlRequest = URLRequest(url: url)

        let (data, response) = try await session.data(for: urlRequest)

        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            try verifyResponse(with: httpResponse)
        }

        guard let image = UIImage(data: data) else {
            return UIImage()
        }

        return image
    }

    func requestCategoryImage(with items: [Category.Item]) async throws -> [UIImage] {
        var imageSet: [UIImage] = []

        for item in items{
            guard let url = URL(string: item.cover) else {
                throw URLComponentsError.invalidComponent
            }

            let urlRequest = URLRequest(url: url)

            let (data, response) = try await session.data(for: urlRequest)

            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                try verifyResponse(with: httpResponse)
            }

            imageSet.append(UIImage(data: data) ?? UIImage())
        }

        return imageSet
    }

    private func verifyResponse(with httpResponse: HTTPURLResponse) throws {
        switch httpResponse.statusCode {
        case (300...399):
            throw HTTPErrorType.redirectionMessages(httpResponse.statusCode, httpResponse.debugDescription)
        case (400...499):
            throw HTTPErrorType.clientErrorResponses(httpResponse.statusCode, httpResponse.debugDescription)
        case (500...599):
            throw HTTPErrorType.serverErrorResponses(httpResponse.statusCode, httpResponse.debugDescription)
        default:
            throw HTTPErrorType.networkFailError(httpResponse.statusCode, httpResponse.debugDescription)
        }
    }

    private func decodeData<D: Decodable>(with requestedData: Data) throws -> D {
        let decodedData = try JSONDecoder().decode(D.self, from: requestedData) as D

        return decodedData
    }

    // MARK: - Private Properties

    private let session: URLSession
}
