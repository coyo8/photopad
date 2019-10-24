//
//  HomeViewControllerDataSource.swift
//  Photopad
//
//  Created by Rahul Ranjan on 19/10/19.
//  Copyright © 2019 Rudrakos. All rights reserved.
//

import UIKit

// Keeping dataSource independent from view controller makes
// it testable
final class HomeViewModel {
  var model: [String]

  init(model: [String]) {
    self.model = model
  }
}


