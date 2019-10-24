//
//  PhotoService.swift
//  Photopad
//
//  Created by Rahul Ranjan on 19/10/19.
//  Copyright © 2019 Rudrakos. All rights reserved.
//

import UIKit

// We can use configurations based on environment type if needed
struct FlickrAPIConfig {
  static let apiKey: String = "76483479d3ffba17e5524cb8471b2ff1"
  static let secret: String = "3b3953302f24cb0a"
}


struct Constant {
  // Force cast is expected here because you can't create a url without it
  // and it fails it means we have wrong url
  static let baseURL = URL(string: "https://api.flickr.com/services/rest/")!

  static let Params = [
    "method" : "flickr.photos.search",
    "api_key" : FlickrAPIConfig.apiKey,
    "sort" : "relevance",
    "per_page" : "20",
    "format" : "json",
    "nojsoncallback" : "1",
    "extras" : "url_m"
  ]
}


// This service handles the flickr requests
public protocol PhotoService {
  func fetchPhotosURLs(with query: String,
                       completion: @escaping (Result<PhotoModel, NetworkError>) -> Void)
  func fetchPhoto(with url: String,
                  completion: @escaping (Result<AnyImage, NetworkError>) -> Void)
}

public final class PhotoServiceImp: PhotoService {
  let networkKit: NetworkKit
  var cache: ImageCacherService

  init(networkKit: NetworkKit = NetworkKitImp(), cache: ImageCacherService = ImageCacher.shared) {
    self.networkKit = networkKit
    self.cache = cache
  }

  private func queryItems(with parameters: [String : String]) -> [URLQueryItem] {
    return parameters.map {
      URLQueryItem(name: $0.0, value: $0.1)
    }
  }

  func getSearchUrl(with query: String) -> URL? {
    guard var components = URLComponents(url: Constant.baseURL, resolvingAgainstBaseURL: true) else {
      return nil
    }

    components.queryItems = self.queryItems(with: Constant.Params)
    components.queryItems?.append(URLQueryItem(name: "text", value: query))
    components.queryItems?.append(URLQueryItem(name: "tags", value: query))
    return components.url
  }


  public func fetchPhotosURLs(with query: String,
                              completion: @escaping (Result<PhotoModel, NetworkError>) -> Void) {

    guard let url = getSearchUrl(with: query) else {
      completion(.failure(NetworkError.invalidURL))
      return
    }

    let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60.0)

    let decoder: (Data) throws -> PhotoModel = { data in
//      print(String(data: data, encoding: .utf8)!)
      do {
        let model = try JSONDecoder().decode(PhotoModel.self, from: data)
        return model
      } catch let error {
        print(error)
        throw NetworkError.decodingFailed
      }
    }

    networkKit.send(request, decoder: decoder) { result in
      switch result {
      case .success(let photos):
        completion(.success(photos))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  public func fetchPhoto(with url: String, completion: @escaping (Result<AnyImage, NetworkError>) -> Void) {
    guard let urlObject = URL(string: url) else {
      completion(.failure(.invalidURL))
      return
    }

    if let image = cache.getImage(for: url as NSString) {
      completion(.success(AnyImage(image: image)))
    } else {
      let decoder: (Data) throws -> AnyImage = { data in
        if let image = UIImage(data: data) { return AnyImage(image: image) }

        throw NetworkError.imageNotFound
      }

      networkKit.send(URLRequest(url: urlObject), decoder: decoder) { [weak self] result in
        guard let this = self else { return }

        switch result {
        case .success(let image):
          this.cache.save(image: image.image, for: url as NSString)
          completion(.success(image))
        case .failure(let error):
          completion(.failure(error))
        }
      }
    }
  }
}
