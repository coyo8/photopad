//
//  PhotoModel.swift
//  Photopad
//
//  Created by Rahul Ranjan on 24/10/19.
//  Copyright © 2019 Rudrakos. All rights reserved.
//

import Foundation


public struct PhotoModel: Codable {
  let photos: Photos
}

public struct Photos: Codable {
  let photo: [Photo]
}

public struct Photo: Codable {
  var url: String?
  let id: String
  let height: Int?
  let width: Int?

  enum CodingKeys: String, CodingKey {
    case id
    case url = "url_m"
    case height = "height_m"
    case width = "width_m"
  }
}
