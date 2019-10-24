//
//  Alerts.swift
//  Photopad
//
//  Created by Rahul Ranjan on 24/10/19.
//  Copyright © 2019 Rudrakos. All rights reserved.
//

import UIKit

class UIKitHelper {
  static func displayAlert(with message: String) -> UIAlertController {
    let alertController = UIAlertController(title: "Failed", message: message, preferredStyle: UIAlertController.Style.alert)
    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    return alertController
  }
}
