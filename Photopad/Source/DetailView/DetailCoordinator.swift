//
//  DetailCoordinator.swift
//  Photopad
//
//  Created by Rahul Ranjan on 25/10/19.
//  Copyright © 2019 Rudrakos. All rights reserved.
//

import UIKit

class PhotoDetailCoordinator : BaseCoordinator {
  var navigationController: UINavigationController?
  let photo: UIImage

  init(photo: UIImage, navigationController: UINavigationController?) {
    self.navigationController = navigationController
    self.photo = photo
    super.init()
  }

  override func start() {
    let detailViewController = PhotoDetailViewController(photo: photo)
    navigationController?.pushViewController(detailViewController, animated: true)
  }
}
