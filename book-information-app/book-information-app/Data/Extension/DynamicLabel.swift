//
//  DynamicLabel.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/30.
//

import UIKit

final class DynamicLabel: UILabel{

    var fullText: String?
    var isTruncated = true
    let truncatedLength = ConstantsNumber.kTruncateLength
    let attributedLength = ConstantsNumber.kAttributeLength

    func collapse() {
        if let fullText = fullText {
            let index = fullText.index(fullText.startIndex, offsetBy: truncatedLength)
            self.text = fullText[...index].description + ConstantsBookDetailText.kMoreDescription
            isTruncated.toggle()
        }
    }

    func expand() {
        if let fullText = fullText {
            self.text = fullText + ConstantsBookDetailText.kLessDescription
            isTruncated.toggle()
        }
    }
}
