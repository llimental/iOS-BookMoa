//
//  HTTPErrorType.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/19.
//

import Foundation

enum HTTPErrorType: Error {
    case redirectionMessages(_ statusCode: Int, _ description: String)
    case clientErrorResponses(_ statusCode: Int, _ description: String)
    case serverErrorResponses(_ statusCode: Int, _ description: String)
    case networkFailError(_ statusCode: Int, _ description: String)
}
