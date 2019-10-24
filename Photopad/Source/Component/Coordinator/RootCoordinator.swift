//
//  RootCoordinator.swift
//  Photopad
//
//  Created by Rahul Ranjan on 25/10/19.
//  Copyright © 2019 Rudrakos. All rights reserved.
//

import UIKit

class RootCoordinator : BaseCoordinator {
  let window : UIWindow

  init(window: UIWindow) {
    self.window = window
    super.init()
  }

  override func start() {
    // preparing root view
    let navigationController = UINavigationController()
    let homeCoordinator = HomeCoordinator(navigationController: navigationController)

    // store child coordinator
    self.store(coordinator: homeCoordinator)
    homeCoordinator.start()

    window.rootViewController = navigationController
    window.makeKeyAndVisible()

    // detect when free it
    homeCoordinator.isCompleted = { [weak self] in
      self?.free(coordinator: homeCoordinator)
    }
  }
}
