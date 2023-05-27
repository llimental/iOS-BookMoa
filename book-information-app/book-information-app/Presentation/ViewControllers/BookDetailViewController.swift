//
//  BookDetailViewController.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/27.
//

import UIKit

final class BookDetailViewController: UIViewController {

    var selectedItem: BestSellerCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green

        print(selectedItem?.booktitleLabel.text)
        print(selectedItem?.bookAuthorLabel.text)
    }
}
