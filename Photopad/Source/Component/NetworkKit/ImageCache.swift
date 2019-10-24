//
//  ImageCache.swift
//  Photopad
//
//  Created by Rahul Ranjan on 24/10/19.
//  Copyright © 2019 Rudrakos. All rights reserved.
//

import UIKit

struct ImageCacher {
  var nscache = NSCache<NSString, UIImage>()

  static let shared = ImageCacher()
  private init() {}

  mutating func getImage(for key: NSString) -> UIImage? {
    return nscache.object(forKey: key)
  }

  mutating func save(image: UIImage, for key: NSString) {
    nscache.setObject(image, forKey: key)
  }
}
