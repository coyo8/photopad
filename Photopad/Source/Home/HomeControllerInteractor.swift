//
//  HomeViewControllerDataSource.swift
//  Photopad
//
//  Created by Rahul Ranjan on 19/10/19.
//  Copyright © 2019 Rudrakos. All rights reserved.
//

import UIKit

public protocol HomeViewInteractorProtocol: class {
  func didFinishFetching(photos: [Photo])
  func showErrorAlert(error: NetworkError)
}

// Keeping dataSource independent from view controller makes
// it testable
final class HomeControllerInteractor: NSObject {

  let photoService: PhotoService

  weak var delegate: HomeViewInteractorProtocol?

  init(photoService: PhotoService = PhotoServiceImp()) {
    self.photoService = photoService
  }

  func searchPhotos(with query: String) {
    photoService.fetchPhotosURLs(with: query) { [weak self] result in
      guard let this = self else { return }

      switch result {
      case .success(let photoModel):
        this.delegate?.didFinishFetching(photos: photoModel.photos.photo)
      case .failure(let error):
        this.delegate?.showErrorAlert(error: error)
      }
    }
  }
}




