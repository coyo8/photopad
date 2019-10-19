//
//  PhotoService.swift
//  Photopad
//
//  Created by Rahul Ranjan on 19/10/19.
//  Copyright © 2019 Rudrakos. All rights reserved.
//

import UIKit

public protocol PhotoService {
  func fetchPhotosURLs<T: Decodable>(url: String,
                                     completion: @escaping (Result<T, NetworkError>) -> Void)
}

public final class PhotoServiceImp: PhotoService {
  let urlSession: URLSession
  let decoder: JSONDecoder

  init(urlSession: URLSession = URLSession.shared,
       decoder: JSONDecoder = JSONDecoder()) {
    self.urlSession = urlSession
    self.decoder = decoder
  }Ç

  public func fetchPhotosURLs<T: Decodable>(url: String,
                                            completion: @escaping (Result<T, NetworkError>) -> Void) {
    guard let url = URL(string: url) else {
      completion(.failure(.invalidURL))
      return
    }

  }
}
