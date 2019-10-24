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
  static let headerId = "com.homeheader"
}

class HomePhotoCell: UICollectionViewCell {
  let imageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    iv.layer.cornerRadius = 5.0
    iv.image = UIImage(named: "placeholder")
    return iv
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    imageView.autolayout()
    addSubview(imageView)
    imageView.toFit(self)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    imageView.image = nil
  }
}
