//
//  PhotopadTests.swift
//  PhotopadTests
//
//  Created by Rahul Ranjan on 19/10/19.
//  Copyright © 2019 Rudrakos. All rights reserved.
//

import XCTest
@testable import Photopad

struct MockPhotoModel {
  func getModel() -> PhotoModel {
    let photo = Photo(url: "https://mockphoto.com",
                      id: "id",
                      height: 20,
                      width: 10)
    let photos = Photos(photo: [photo])
    return PhotoModel(photos: photos)
  }
}

class MockPhotoService: PhotoService {
  var isPhotoURLsSuccess = false
  func fetchPhotosURLs(with query: String, completion: @escaping (Result<PhotoModel, NetworkError>) -> Void) {
    if isPhotoURLsSuccess {
      let model = MockPhotoModel().getModel()
      completion(.success(model))
    } else {
      completion(.failure(NetworkError.dataNotFound))
    }
  }

  var isPhotoSuccess = false
  func fetchPhoto(with url: String, completion: @escaping (Result<AnyImage, NetworkError>) -> Void) {
    if isPhotoSuccess {
      completion(.success(AnyImage(image: UIImage())))
    } else {
      completion(.failure(NetworkError.dataNotFound))
    }
  }
}


class PhotopadTests: XCTestCase {
  override func setUp() {
    super.setUp()
  }

  func testFetchURLsSuccess() {
    // given
    let service = MockPhotoService()

    // when
    service.isPhotoURLsSuccess = true

    // then
    service.fetchPhotosURLs(with: "hello") { (result: Result<PhotoModel, NetworkError>) -> Void in
      switch result {
      case .success(let val):
        XCTAssertNotNil(val.photos.photo[0].url)
      case .failure:
        XCTFail()
      }
    }
  }

  func testFetchTransactionFailure() {
    // given
    let service = MockPhotoService()

    // when
    service.isPhotoURLsSuccess = false

    // then
    service.fetchPhotosURLs(with: "hello") { (result: Result<PhotoModel, NetworkError>) -> Void in
      switch result {
      case .success:
        XCTFail()
      case .failure(let error):
        XCTAssertNoThrow(error)
      }
    }
  }
}
