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
final class HomeViewControllerDataSource: NSObject {
  var model: [String]

  init(model: [String]) {
    self.model = model
  }
}

extension HomeViewControllerDataSource:  UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return 10
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCellConstant.cellId, for: indexPath)
    cell.backgroundColor = .red
    return cell
  }
}
