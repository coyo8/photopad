//
//  PhotoDetailViewController.swift
//  Photopad
//
//  Created by Rahul Ranjan on 25/10/19.
//  Copyright © 2019 Rudrakos. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {

  var didTapBack: (() -> Void)?

  private lazy var scrollView: UIScrollView = {
    let sv = UIScrollView()
    sv.maximumZoomScale = 3.0
    sv.minimumZoomScale = 1.0
    sv.delegate = self
    sv.contentMode = .scaleToFill
    sv.clipsToBounds = true
    sv.alwaysBounceVertical = false
    sv.alwaysBounceHorizontal = false
    sv.showsVerticalScrollIndicator = true
    sv.showsHorizontalScrollIndicator = true
    sv.autoresizesSubviews = false
    return sv
  }()

  private let photoImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.clipsToBounds = true
    return iv
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .black
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                        target: self,
                                                        action: #selector(handleSave))
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Back",
                                                       style: .plain,
                                                       target: self,
                                                       action: #selector(backPressed))
    setupViews()
  }

  init(photo: UIImage) {
    photoImageView.image = photo
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupViews() {
    let guide = view.safeAreaLayoutGuide
    scrollView.autolayout()
    photoImageView.autolayout()
    view.addSubview(scrollView)
    scrollView.addSubview(photoImageView)

    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: guide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),

      photoImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
      photoImageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
    ])
  }

  @objc private func handleSave() {
    let alert = UIKitHelper.displayAlert(with: "TODO: Saving image to camera roll")
    present(alert, animated: true, completion: nil)
  }

  @objc private func backPressed() {
    _ = navigationController?.popViewController(animated: true)

    didTapBack?()
  }
}

extension PhotoDetailViewController: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return self.photoImageView
  }
}
