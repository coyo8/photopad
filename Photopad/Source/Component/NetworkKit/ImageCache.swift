//
//  ImageCache.swift
//  Photopad
//
//  Created by Rahul Ranjan on 24/10/19.
//  Copyright © 2019 Rudrakos. All rights reserved.
//

import UIKit

enum StorageError: Error {
  case encodingFailed
  case decodingFailed
}


// Opaque container type
public struct AnyImage: Codable {
  public let image: UIImage

  public enum CodingKeys: String, CodingKey {
    case image
  }

  public init(image: UIImage) {
    self.image = image
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let data = try container.decode(Data.self, forKey: CodingKeys.image)
    guard let image = UIImage(data: data) else {
      throw StorageError.decodingFailed
    }

    self.image = image
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    guard let data = image.jpegData(compressionQuality: 0.5) else {
      throw StorageError.encodingFailed
    }

    try container.encode(data, forKey: CodingKeys.image)
  }
}

public protocol ImageCacherService {
  func getImage(for key: NSString) -> UIImage?
  mutating func save(image: UIImage, for key: NSString)
}

struct ImageCacher: ImageCacherService {
  var nscache = NSCache<NSString, UIImage>()

  static let shared = ImageCacher()
  private init() {}

  func getImage(for key: NSString) -> UIImage? {
    return nscache.object(forKey: key)
  }

  mutating func save(image: UIImage, for key: NSString) {
    nscache.setObject(image, forKey: key)
  }
}
