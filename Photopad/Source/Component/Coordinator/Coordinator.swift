//
//  Coordinator.swift
//  Photopad
//
//  Created by Rahul Ranjan on 25/10/19.
//  Copyright © 2019 Rudrakos. All rights reserved.
//

protocol Coordinator : class {
  var childCoordinators : [Coordinator] { get set }
  func start()
}

extension Coordinator {

  func store(coordinator: Coordinator) {
    childCoordinators.append(coordinator)
  }

  func free(coordinator: Coordinator) {
    childCoordinators = childCoordinators.filter { $0 !== coordinator }
  }
}

class BaseCoordinator : Coordinator {
  var childCoordinators : [Coordinator] = []
  var isCompleted: (() -> ())?

  func start() {
    fatalError("Children should implement `start`.")
  }
}


