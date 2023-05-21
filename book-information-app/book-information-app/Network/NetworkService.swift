//
//  NetworkService.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/18.
//

import Foundation

final class NetworkService {

    // MARK: - Initialization
    
    init() {
        session = URLSession(configuration: .default)
    }

    // MARK: - Public Functions

    func receiveBestSellerData() {
        Task {
            let networkResult = try await requestData(with: BestSellerEndPoint())
            print(networkResult)
        }
    }
    
    // MARK: - Private Functions
    
    private func requestData<D: Decodable, R: RequestableAndResponsable>(with endPoint: R) async throws -> D where R.Response == D {
        let urlRequest = try endPoint.makeURLRequest()

        let (data, response) = try await session.data(for: urlRequest)

        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            try verifyResponse(with: httpResponse)
        }

        let decodedData: D = try decodeData(with: data)

        return decodedData
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
