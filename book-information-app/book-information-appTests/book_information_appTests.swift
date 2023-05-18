//
//  book_information_appTests.swift
//  book-information-appTests
//
//  Created by 이상윤 on 2023/05/17.
//

import XCTest
@testable import book_information_app

final class book_information_appTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func test_Bundle_설정값이_nil이_아닌지_확인() {
        // Given
        let bundle = Bundle(for: type(of: self))

        // Then
        XCTAssertNotNil(bundle)
    }

    func test_filePath가_nil이_아닌지_확인() {
        // Given
        let bundle = Bundle(for: type(of: self))

        // When
        guard let filePath = bundle.path(forResource: "BestSeller", ofType: "json") else { return }

        // Then
        XCTAssertNotNil(filePath)
    }

    func test_MockData가_nil이_아닌지_확인() {
        // Given
        let bundle = Bundle(for: type(of: self))

        guard let filePath = bundle.path(forResource: "BestSeller", ofType: "json") else { return }

        // When
        guard let jsonString = try? String(contentsOfFile: filePath) else { return }

        // Then
        XCTAssertNotNil(jsonString)
    }

    func test_jsonString이_data로_변환이_잘_되었는지_확인() {
        // Given
        let bundle = Bundle(for: type(of: self))

        guard let filePath = bundle.path(forResource: "BestSeller", ofType: "json") else { return }

        guard let jsonString = try? String(contentsOfFile: filePath) else { return }

        // When
        guard let data = jsonString.data(using: .utf8) else { return }

        // Then
        XCTAssertNotNil(data)
    }

    func test_data를_DTO로_파싱한_결과가_nil이_아닌지_확인() {
        // Given
        let bundle = Bundle(for: type(of: self))

        guard let filePath = bundle.path(forResource: "BestSeller", ofType: "json") else { return }

        guard let jsonString = try? String(contentsOfFile: filePath) else { return }

        guard let data = jsonString.data(using: .utf8) else { return }

        // When
        let decodedData = try? JSONDecoder().decode(BestSeller.self, from: data)

        // Then
        XCTAssertNotNil(decodedData)
    }

    func test_decodedData의_publishDate가_맞게_들어왔는지_확인() {
        // Given
        let bundle = Bundle(for: type(of: self))

        guard let filePath = bundle.path(forResource: "BestSeller", ofType: "json") else { return }

        guard let jsonString = try? String(contentsOfFile: filePath) else { return }

        guard let data = jsonString.data(using: .utf8) else { return }

        guard let decodedData = try? JSONDecoder().decode(BestSeller.self, from: data) else { return }

        // When
        let publishDate = decodedData.publishDate
        let mockPublishDate = "Thu, 18 May 2023 02:45:08 GMT"  // MockData/BestSeller.json의 pubDate 값

        // Then
        XCTAssertEqual(publishDate, mockPublishDate)
    }

    func test_decodedData의_item이_맞게_들어왔는지_확인() {
        // Given
        let bundle = Bundle(for: type(of: self))

        guard let filePath = bundle.path(forResource: "BestSeller", ofType: "json") else { return }

        guard let jsonString = try? String(contentsOfFile: filePath) else { return }

        guard let data = jsonString.data(using: .utf8) else { return }

        guard let decodedData = try? JSONDecoder().decode(BestSeller.self, from: data) else { return }

        // When
        guard let firstItem = decodedData.item.first else { return }
        let mockFirstItemTitle = "여학교의 별 3"  // MockData/BestSeller.json의 첫 번째 Item의 title 값

        // Then
        XCTAssertEqual(firstItem.title, mockFirstItemTitle)
    }
}
