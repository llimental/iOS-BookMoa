//
//  PreviewViewController.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/06/07.
//

import UIKit

final class PreviewViewController: UIViewController {

    // MARK: - Public Properties

    var imageIndex: Int = ConstantsNumber.kNumberZero
    var imageLinks: [String] = [] {
        didSet {
            setPreviewImage()
        }
    }

    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureGestures()
        configure()
    }

    // MARK: - Private Properties

    private lazy var blurView = UIVisualEffectView(effect: blurEffect)
    private let blurEffect = UIBlurEffect(style: .light)
    private let previewContainerView = UIView()
    private let imageView = UIImageView()
    private let closeButton = UIButton()
}

extension PreviewViewController {

    // MARK: - Private Functions

    private func configureGestures() {
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureAction))
        swipeLeftGesture.direction = .left

        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureAction))
        swipeRightGesture.direction = .right

        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureAction))
        swipeDownGesture.direction = .down

        view.addGestureRecognizer(swipeLeftGesture)
        view.addGestureRecognizer(swipeRightGesture)
        view.addGestureRecognizer(swipeDownGesture)
    }

    private func configure() {
        view.addSubview(blurView)
        view.addSubview(previewContainerView)

        previewContainerView.addSubview(imageView)
        previewContainerView.addSubview(closeButton)

        imageView.contentMode = .scaleAspectFit

        closeButton.setBackgroundImage(UIImage(systemName: ConstantsCloseButton.kImageName), for: .normal)
        closeButton.tintColor = ConstantsColor.kMainColor
        closeButton.contentMode = .center
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)

        blurView.translatesAutoresizingMaskIntoConstraints = false
        previewContainerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            previewContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            previewContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            previewContainerView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            previewContainerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),

            imageView.widthAnchor.constraint(equalTo: previewContainerView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: previewContainerView.heightAnchor, multiplier: 0.8),
            imageView.centerXAnchor.constraint(equalTo: previewContainerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: previewContainerView.centerYAnchor),

            closeButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            closeButton.widthAnchor.constraint(equalTo: previewContainerView.heightAnchor, multiplier: 0.05),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),
            closeButton.centerXAnchor.constraint(equalTo: previewContainerView.centerXAnchor)
        ])
    }

    private func setPreviewImage() {
        guard imageLinks.indices.contains(imageIndex) else {
            imageView.image = nil
            return
        }

        guard let url = URL(string: imageLinks[imageIndex]) else {
            imageView.image = nil
            return
        }

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }
    }

    @objc private func swipeGestureAction(_ gesture: UISwipeGestureRecognizer) {

        switch gesture.direction {
        case .left:
            if imageIndex < imageLinks.count - ConstantsNumber.kNumberOne {
                imageIndex += ConstantsNumber.kNumberOne
                UIView.transition(with: imageView, duration: 0.3, options: .transitionCrossDissolve, animations: { self.setPreviewImage() }, completion: nil)
            }
        case .right:
            if imageIndex > ConstantsNumber.kNumberZero {
                imageIndex -= ConstantsNumber.kNumberOne
                UIView.transition(with: imageView, duration: 0.3, options: .transitionCrossDissolve, animations: { self.setPreviewImage() }, completion: nil)
            }
        case .down:
            dismiss(animated: true)
        default:
            break
        }
    }

    @objc private func closeButtonTapped() {
        self.dismiss(animated: true)
    }
}
