//
//  ViewController.swift
//  FreelyUsableImages
//
//  Created by Evgeniy Opryshko on 20.07.2020.
//  Copyright © 2020 Evgeniy Opryshko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	//MARK: - IBOutlet
	
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	//MARK: - Private Properties
	
	private var viewModel: MainViewModel!
	private var fetcherManager: DataFetcherProtocol!
	
	// MARK: - Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		
		fetcherManager = NetworkDataFetcher(networking: NetworkService())
		viewModel = MainViewModel()
		
		setupSearchBar()
		setupCollectionView()
		
		activityIndicator.hidesWhenStopped = true
		
		fetchImages(page: viewModel.getPageCount())
	}
}

//MARK: -

private extension ViewController {
	
	func fetchImages(page: Int) {
		
		startLoading()
		
		fetcherManager.fetchPhotos(page: page) { [weak self] result in
			
			guard let self = self else { return }
			
			switch result {
				
			case .success(let photos):
				
				self.viewModel.savePhotos(photos)
				
				self.reloadCollectionView()
				
				self.finishLoading()
				
			case .failure(let error):
				
				self.finishLoadingWith(error: error)
			}
		}
	}
	
	func searchImagesBy(name: String) {
		
		startLoading()
		
		fetcherManager.searchPhotoBy(name: name) { [weak self] result in
			
			guard let self = self else { return }
			
			switch result {
				
			case .success(let photos):
				
				self.viewModel.savefoundPhoto(photos.results)
				
				self.reloadCollectionView()
				
				self.finishLoading()
				
			case .failure(let error):
			
				self.finishLoadingWith(error: error)
			}
		}
	}
}

//MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return viewModel.numberOfItemsInSection()
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
		
		let cellViewModel = viewModel.cellForItemAt(indexPath)
		cell.delegate = self
		cell.configure(with: cellViewModel)
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let noOfCellsInRow = viewModel.noOfCellsInRow()
		let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
		let totalSpace = flowLayout.sectionInset.left
			+ flowLayout.sectionInset.right
			+ (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
		
		let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
		
		return CGSize(width: size, height: size)
	}
}

//MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let stringUrl = viewModel.didSelectItemAt(indexPath)
		
		imageTapped(url: stringUrl)
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		
		let photosCount = viewModel.numberOfItemsInSection()
		
		if indexPath.row == photosCount - 1 && photosCount < Constants.totalCount {
			
			viewModel.updatePageCount()
			
			fetchImages(page: viewModel.getPageCount())
		}
	}
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets.zero
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0
	}
}

// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
	
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
				
		if searchText.count > Constants.countOfCharacters {
			viewModel.updateState(with: .search)
			self.searchImagesBy(name: searchText)
		}
    }
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		
		viewModel.updateState(with: .main)
		
		reloadCollectionView()
	}
}

//MARK:- ImageCollectionViewCellDelegate

extension ViewController: ImageCollectionViewCellDelegate {
	
	func didTouchDelete(cell: UICollectionViewCell) {
		
		if let indexPath = collectionView.indexPath(for: cell) {
			
			viewModel.removeItemAt(indexPath)
			
			self.collectionView.performBatchUpdates({
				self.collectionView.deleteItems(at:[indexPath])
			}, completion:nil)
        }
	}
}

//MARK: - Helpers

private extension ViewController {
	
	func setupSearchBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
	
	func setupCollectionView() {
		collectionView.register(UINib(nibName: String(describing: ImageCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ImageCollectionViewCell.self))
	}
	
	func imageTapped(url: String) {
		
		guard let url = URL(string: url) else { return }
		
		let view = FullScreenImageView(url: url)
		view.frame = UIScreen.main.bounds
		self.view.addSubview(view)
		
		self.navigationController?.isNavigationBarHidden = true
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
		view.addGestureRecognizer(tap)

	}
	
	@objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
		self.navigationController?.isNavigationBarHidden = false
		self.tabBarController?.tabBar.isHidden = false
		sender.view?.removeFromSuperview()
	}
}

//MARK: - Setting Loader

private extension ViewController {
	
	func reloadCollectionView() {
		DispatchQueue.main.async {
			self.collectionView.reloadData()
		}
	}
	
	func startLoading() {
		activityIndicator.startAnimating()
	}
	
	func finishLoading() {
		DispatchQueue.main.async {
			self.activityIndicator.stopAnimating()
		}
	}
	
	func finishLoadingWith(error: Error) {
		
		DispatchQueue.main.async {
			self.activityIndicator.stopAnimating()
			self.showAlert(with: "Loading failed", and: error.localizedDescription)
		}
	}
}
