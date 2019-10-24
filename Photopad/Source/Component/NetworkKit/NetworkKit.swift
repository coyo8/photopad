//
//  NetworkKit.swift
//  Photopad
//
//  Created by Rahul Ranjan on 19/10/19.
//  Copyright © 2019 Rudrakos. All rights reserved.
//

import UIKit

public enum NetworkError: Error {
  case serverError
  case invalidURL
  case requestFailed
  case decodingFailed
  case dataNotFound
  case decoderNotFound
  case imageNotFound
}



// This way we can test our network layer
// as we can provide our mock implmentation
public protocol NetworkKit {
  func send<T: Decodable>(_ r: URLRequest, decoder: ((Data) throws -> (T))?,
                          completion: @escaping (Result<T, NetworkError>) -> Void)
}

final class NetworkKitImp: NetworkKit {
  let urlSession: URLSession

  init(urlSession: URLSession = URLSession.shared) {
    self.urlSession = urlSession
  }

  func send<T: Decodable>(_ r: URLRequest, decoder: ((Data) throws -> (T))? = nil,
                          completion: @escaping (Result<T, NetworkError>) -> Void) {

    urlSession.dataTask(with: r) { (data, response, error) in

      if error != nil {
        completion(.failure(.requestFailed))
      }

      if let urlResponse = response as? HTTPURLResponse {
        if (400...500).contains(urlResponse.statusCode) {
          completion(.failure(.serverError))
        }
      }

      guard let data = data else {
        completion(.failure(.dataNotFound))
        return
      }

      if let decoder = decoder {
        do {
          let model = try decoder(data)
          completion(.success(model))
        } catch {
          completion(.failure(.decodingFailed))
        }
      } else {
        completion(.failure(.decoderNotFound))
      }
    }.resume()
  }
}
