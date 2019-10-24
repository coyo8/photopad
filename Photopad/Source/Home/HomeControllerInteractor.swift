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
  func didFinishLoadingImage(image: UIImage, for url: String)
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

  func loadImage(with url: String) {
    photoService.fetchPhoto(with: url) { [weak self] result in
      guard let this = self else { return }

      switch result {
      case .success(let anyImage):
        this.delegate?.didFinishLoadingImage(image: anyImage.image, for: url)
      case .failure:
        this.delegate?.didFinishLoadingImage(image: UIImage(named: "placeHolder")!, for: url)
      }
    }
  }
}



