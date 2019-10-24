//
//  HomeViewModel.swift
//  Photopad
//
//  Created by Rahul Ranjan on 24/10/19.
//  Copyright © 2019 Rudrakos. All rights reserved.
//

import UIKit

struct ImageConstant {
  static let placeholder = "placeHolder"
}

class HomeViewModel {
  private var container = [String: UIImage]()
  private let queue = DispatchQueue(label: "com.home.photopad")

  init() {}

  var count: Int {
    return queue.sync { self.container.count }
  }

  var urls: [String] {
    return queue.sync { Array(container.keys) }
  }

  func getIndexPath(for key: String) -> IndexPath? {
    if container.keys.contains(key),
      let index = Array(container.keys).firstIndex(of: key) {
      return IndexPath(row: index, section: 0)
    }
    return nil
  }

  func getPhotoAt(indexPath: IndexPath) -> UIImage? {
    if indexPath.row < count {
      let key = Array(container.keys)[indexPath.row]
      return queue.sync { container[key] }
    }

    return nil
  }

  func updatePhoto(for key: String, with value: UIImage) {
    container.updateValue(value, forKey: key)
  }

  func updateAll(with photos: [Photo]) {
    container = [String: UIImage]()
    photos.filter({ $0.url != nil }).forEach { elem in
      queue.sync { self.container.updateValue(UIImage(), forKey: elem.url!) }
    }
  }
}
