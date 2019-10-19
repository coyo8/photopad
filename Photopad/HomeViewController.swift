//
//  ViewController.swift
//  Photopad
//
//  Created by Rahul Ranjan on 19/10/19.
//  Copyright © 2019 Rudrakos. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController {
  let dataSource = HomeViewControllerDataSource(model: [])

  override func loadView() {
    super.loadView()

    collectionView.delegate = self
    collectionView.register(UICollectionViewCell.self,
                            forCellWithReuseIdentifier: HomeCellConstant.cellId)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.backgroundColor = .white
    navigationItem.title = "Home"

    // setup the datasource
    collectionView.dataSource = dataSource
  }
}

