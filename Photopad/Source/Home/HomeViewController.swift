//
//  ViewController.swift
//  Photopad
//
//  Created by Rahul Ranjan on 19/10/19.
//  Copyright © 2019 Rudrakos. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController {
  let interactor = HomeControllerInteractor()
  var viewModel = [Photo]()

  override func loadView() {
    super.loadView()

    collectionView.delegate = self
    collectionView.register(UICollectionViewCell.self,
                            forCellWithReuseIdentifier: HomePhotoCellConstant.cellId)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.backgroundColor = .white
    navigationItem.title = "Home"

    // setup the datasource
    collectionView.dataSource = self
    interactor.delegate = self

    interactor.searchPhotos(with: "dog")
  }
}


extension HomeViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.count
  }

  override func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePhotoCellConstant.cellId, for: indexPath)
    cell.backgroundColor = .red
    return cell
  }
}

extension HomeViewController: HomeViewInteractorProtocol {
  func didFinishFetching(photos: [Photo]) {
    viewModel = photos
    DispatchQueue.main.async {
      self.collectionView.reloadData()
    }
  }

  func showErrorAlert(error: NetworkError) {
    DispatchQueue.main.async {
      let alert = UIKitHelper.displayAlert(with: error.localizedDescription)
      self.present(alert, animated: true, completion: nil)
    }
  }
}
