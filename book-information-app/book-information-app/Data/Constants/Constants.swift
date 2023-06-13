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
}

enum ConstantsString {
    static let kBlank: String = ""
    static let kLaunchAnimationName: String = "77792-book"
    static let kDetailViewBackgroundImageName: String = "EclipseIcon"
}

enum ConstantsTabBarItem {
    static let kTabBarHomeTitle: String = "홈"
    static let kTabBarHomeImageName: String = "HomeIcon"
    static let kTabBarFavoriteTitle: String = "즐겨찾기"
    static let kTabBarFavoriteImageName: String = "FavoriteIcon"
}

enum ConstantsSearchController {
    static let kSearchControllerImageName: String = "SearchBarIcon"
}

enum ConstantsSupplementaryView {
    static let kBestSellerSectionImageName: String = "StarIcon"
    static let kCategorySectionImageName: String = "SearchRefractionIcon"
}

enum ConstantsFavoritesButton {
    static let kColor: UIColor = UIColor(red: 0.88, green: 0.04, blue: 0.55, alpha: 1.00)
    static let kImageName: String = "heart.fill"
}
