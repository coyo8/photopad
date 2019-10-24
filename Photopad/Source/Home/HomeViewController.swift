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
  var viewModel = HomeViewModel()

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

    collectionView.register(HomePhotoCell.self,
                            forCellWithReuseIdentifier: HomePhotoCellConstant.cellId)
    collectionView.register(UICollectionReusableView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: HomePhotoCellConstant.headerId)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView.backgroundColor = .black
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
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePhotoCellConstant.cellId, for: indexPath) as? HomePhotoCell else { return UICollectionViewCell() }

    cell.backgroundColor = .lightRed
    DispatchQueue.main.async {
      cell.imageView.image = self.viewModel.getPhotoAt(indexPath: indexPath)
      cell.layoutIfNeeded()
    }
    return cell
  }
}

// MARK: UI Stuffs
extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width
    let height = collectionView.frame.height / 3.0
    return CGSize(width: width, height: height)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: view.frame.width, height: 40)
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
    // update the viewModel and reload collection
    // view
    viewModel.updateAll(with: photos)
    print(viewModel.urls)
    DispatchQueue.main.async {
      self.collectionView.reloadData()
    }

    // Start fetching the images
    // in background
    DispatchQueue.global().async {
      self.viewModel.urls.forEach {
        self.interactor.loadImage(with: $0)
      }
    }
  }

  func showErrorAlert(error: NetworkError) {
    DispatchQueue.main.async {
      let alert = UIKitHelper.displayAlert(with: error.localizedDescription)
      self.present(alert, animated: true, completion: nil)
    }
  }

  func didFinishLoadingImage(image: UIImage, for url: String) {
    viewModel.updatePhoto(for: url, with: image)

    if let indexPath = viewModel.getIndexPath(for: url) {
      DispatchQueue.main.async {
        self.collectionView.reloadItems(at: [indexPath])
      }
    }
  }
}
