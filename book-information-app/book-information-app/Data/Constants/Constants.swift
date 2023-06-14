//
//  Constants.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/06/12.
//

import UIKit

enum ConstantsColor {
    static let kMainColor: UIColor = UIColor(red: 0.38, green: 0.13, blue: 0.93, alpha: 1.00)
    static let kDividerColor: UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.00)
    static let kGrayTextColor: UIColor = UIColor(red: 0.29, green: 0.31, blue: 0.34, alpha: 1.00)
}

enum ConstantsString {
    static let kBlank: String = ""
    static let kLaunchAnimationName: String = "77792-book"
    static let kDetailViewBackgroundImageName: String = "EclipseIcon"
    static let kRefreshControlTitle: String = "데이터를 로딩중입니다. 잠시만 기다려 주세요..."
    static let kInformationProviderText: String = "도서 DB 제공 : 알라딘 인터넷서점(www.aladin.co.kr)"
}

enum ConstantsNumber {
    static let kZero: Int = 0
    static let kOne: Int = 1
    static let kTruncateLength: Int = 100
    static let kAttributeLength: Int = 7
}

enum ConstantsTabBarItem {
    static let kHomeTitle: String = "홈"
    static let kHomeImageName: String = "HomeIcon"
    static let kFavoriteTitle: String = "즐겨찾기"
    static let kFavoriteImageName: String = "FavoriteIcon"
}

enum ConstantsSearchController {
    static let kImageName: String = "SearchBarIcon"
    static let kTitle: String = "검색어: "
}

enum ConstantsSupplementaryView {
    static let kBestSellerSectionImageName: String = "StarIcon"
    static let kBestSellerSectionDisclosureName: String = "chevron.right"
    static let kCategorySectionImageName: String = "SearchRefractionIcon"
}

enum ConstantsFavorites {
    static let kColor: UIColor = UIColor(red: 0.88, green: 0.04, blue: 0.55, alpha: 1.00)
    static let kButtonImageName: String = "heart.fill"
    static let kCellImageName: String = "heart.square.fill"
    static let favoritesTextForKey: String = "favorites"
}

enum ConstantsBookDetailColor {
    static let kTitle: UIColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
    static let kAuthor: UIColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 0.60)
    static let kPublish: UIColor = UIColor(red: 0.53, green: 0.56, blue: 0.59, alpha: 1.00)
    static let kMemoBackground: UIColor = UIColor(red: 0.91, green: 0.91, blue: 0.99, alpha: 1.00)
}

enum ConstantsBookDetailText {
    static let kPreviewButtonTitle: String = "미리보기"
    static let kBookDescriptionHead: String = "줄거리"
    static let kAuthorDescriptionHead: String = "저자소개"
    static let kMoreDescription: String = "... 더보기"
    static let kLessDescription: String = "... 줄이기"
    static let kMemoPlaceholder: String = "이 책에 대한 메모를 남겨주세요!"
}

enum ConstantsCloseButton {
    static let kImageName: String = "xmark.circle"
}

enum ConstantsCategoryCell {
    static let kGradientSubColor: UIColor = UIColor(red: 0.49, green: 0.31, blue: 0.91, alpha: 1.00)
    static let kBackgroundColor: UIColor = UIColor(red: 0.87, green: 0.89, blue: 0.90, alpha: 1.00)
}

enum ConstantsReuseIdentifier {
    static let kBestSeller: String = "bestseller-reuse-identifier"
    static let kCategory: String = "category-reuse-identifier"
    static let kCategoryBook: String = "category-book-reuse-identifier"
    static let kSupplementary: String = "title-supplementary-reuse-identifier"
}
