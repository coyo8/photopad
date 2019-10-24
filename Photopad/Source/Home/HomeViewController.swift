//
//  ViewController.swift
//  Photopad
//
//  Created by Rahul Ranjan on 19/10/19.
//  Copyright © 2019 Rudrakos. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController {

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
    photos()
  }

  func photos() {
    let photoService = PhotoServiceImp()

    photoService.fetchPhotosURLs(with: "dogs") { result in
      switch result {
      case .success(let photos):
        print(photos)
      case .failure(let error):
        print(error)
      }
    }
  }
}


extension HomeViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }

  override func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePhotoCellConstant.cellId, for: indexPath)
    cell.backgroundColor = .red
    return cell
  }
}
