//
//  Autolayout.swift
//  Photopad
//
//  Created by Rahul Ranjan on 24/10/19.
//  Copyright © 2019 Rudrakos. All rights reserved.
//

import UIKit

// As the app is small and so I am using a single extension for all the utilities, we
// can segrated this with Class+ExtensionName later e.g. UIView+Autolayout.swift
extension UIView {
  func autolayout() {
    self.translatesAutoresizingMaskIntoConstraints = false
  }

  func toFit(_ parent: UIView) {
    parent.addSubview(self)

    let constraints: [NSLayoutConstraint] = [
      self.topAnchor.constraint(equalTo: parent.topAnchor),
      self.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
      self.leftAnchor.constraint(equalTo: parent.leftAnchor),
      self.rightAnchor.constraint(equalTo: parent.rightAnchor)
    ]

    NSLayoutConstraint.activate(constraints)
  }
}


extension UIColor {
  static let lightRed = UIColor(red: 0.7569, green: 0.3765, blue: 0.3765, alpha: 1.0)
}
