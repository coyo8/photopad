//
//  HomeCoordinator.swift
//  Photopad
//
//  Created by Rahul Ranjan on 25/10/19.
//  Copyright © 2019 Rudrakos. All rights reserved.
//

import UIKit

class HomeCoordinator : BaseCoordinator {
  var navigationController: UINavigationController?

  init(navigationController: UINavigationController?) {
    self.navigationController = navigationController
    super.init()
  }

  override func start() {
    let viewModel = HomeViewModel()
    let interactor = HomeControllerInteractor()
    let homeViewController = HomeViewController(viewModel: viewModel, interactor: interactor)

    navigationController?.pushViewController(homeViewController, animated: true)
  }

  func showPhotoDetail(_ photo: UIImage, in navigationController: UINavigationController?) {
    let photoDetailCoordinator = PhotoDetailCoordinator(photo: photo, navigationController: navigationController)
    self.store(coordinator: photoDetailCoordinator)
  }
}
