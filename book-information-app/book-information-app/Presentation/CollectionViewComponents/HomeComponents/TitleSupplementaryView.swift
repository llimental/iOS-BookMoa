//
//  TitleSupplementaryView.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/22.
//

import UIKit

final class TitleSupplementaryView: UICollectionReusableView {
    static let reuseIdentifier = ConstantsReuseIdentifier.kSupplementary

    let titleLabel = UILabel()
    let titleDecorateImageView = UIImageView()
    let disclosureImageView = UIImageView()
    let blankView = UIView()

    private let titleStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension TitleSupplementaryView {
    private func configure() {
        titleStackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleStackView)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(titleDecorateImageView)
        titleStackView.addArrangedSubview(blankView)
        titleStackView.addArrangedSubview(disclosureImageView)

        titleStackView.axis = .horizontal
        titleStackView.spacing = 7

        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)

        titleDecorateImageView.contentMode = .scaleAspectFit

        disclosureImageView.image = UIImage(systemName: ConstantsSupplementaryView.kBestSellerSectionDisclosureName)
        disclosureImageView.contentMode = .scaleAspectFit

        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
}
