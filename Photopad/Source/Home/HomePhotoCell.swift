//
//  HomePhotoCell.swift
//  Photopad
//
//  Created by Rahul Ranjan on 19/10/19.
//  Copyright © 2019 Rudrakos. All rights reserved.
//

import UIKit

public struct HomePhotoCellConstant {
  static let cellId = "com.homephotocell"
}

class HomePhotoCell: UICollectionViewCell {
  private let imageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    iv.image = #imageLiteral(resourceName: "image_placeholder")
    return iv
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(imageView)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    imageView.image = nil
  }
}
