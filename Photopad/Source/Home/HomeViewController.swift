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

  private lazy var searchBar: UISearchBar = {
    let sb = UISearchBar(frame: .zero)
    sb.placeholder = "Search image.."
    sb.searchBarStyle = .prominent
    sb.barTintColor = .lightGray
    sb.sizeToFit()
    let textFieldInsideSearchBar = sb.value(forKey: "searchField") as? UITextField
    textFieldInsideSearchBar?.backgroundColor = UIColor.lightGray
    sb.delegate = self
    return sb
  }()

  override func loadView() {
    super.loadView()

    collectionView.delegate = self
    collectionView.dataSource = self

    collectionView.register(UICollectionViewCell.self,
                            forCellWithReuseIdentifier: HomePhotoCellConstant.cellId)
    collectionView.register(UICollectionReusableView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: HomePhotoCellConstant.headerId)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.backgroundColor = .lightRed
    navigationItem.title = "Home"

    // setup the datasource
    collectionView.dataSource = self
    interactor.delegate = self
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

  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                 withReuseIdentifier: HomePhotoCellConstant.headerId,
                                                                 for: indexPath)
    header.addSubview(searchBar)
    searchBar.autolayout()

    NSLayoutConstraint.activate([
      searchBar.topAnchor.constraint(equalTo: header.topAnchor),
      searchBar.leadingAnchor.constraint(equalTo: header.leadingAnchor),
      searchBar.trailingAnchor.constraint(equalTo: header.trailingAnchor),
      searchBar.bottomAnchor.constraint(equalTo: header.bottomAnchor)
    ])

    return header
  }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width
    let height = collectionView.frame.height / 2.0
    return CGSize(width: width, height: height)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: view.frame.width, height: 40)
  }
}

extension HomeViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard var query = searchBar.text else { return }
    query = query.trimmingCharacters(in: .whitespacesAndNewlines)
      .replacingOccurrences(of: " ", with: "+")

    if query.isEmpty {
      let alert = UIKitHelper.displayAlert(with: "Enter valid text")
      self.present(alert, animated: true, completion: nil)
    }

    interactor.searchPhotos(with: query)
  }
}


// MARK: HomeViewInteractorProtocol
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
