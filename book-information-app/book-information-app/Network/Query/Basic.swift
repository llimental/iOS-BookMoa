//
//  Basic.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/18.
//

import Foundation

enum Basic {
    static let baseURL: String = "http://www.aladin.co.kr/ttb/api/"
    static let keyParameter: String = "ttbkey"
    static let key: String = ""
    static let output: String = "output"
    static let apiVersion: String = "Version"
}

enum OutputType: String {
    case json = "js"
}

enum APIVersion: String {
    case versionNumber = "20131101"
}
