//
//  ViewControllerViewModel.swift
//  FreelyUsableImages
//
//  Created by Evgeniy Opryshko on 21.07.2020.
//  Copyright © 2020 Evgeniy Opryshko. All rights reserved.
//

import Foundation

protocol MainViewModelProtocol: class {
	
	func savePhotos(_ photoList: [Photo])
	func savefoundPhoto(_ foundPhotoList: [Photo])
	
	func numberOfItemsInSection() -> Int
	func didSelectItemAt(_ indexPath: IndexPath) -> String
	func cellForItemAt(_ indexPath: IndexPath) -> ImageCollectionViewCellViewModel
	func noOfCellsInRow() -> Int
	func removeItemAt(_ indexPath: IndexPath)
	
	func getState() -> State
	func updateState(with: State)
	
	func getPageCount() -> Int
	func updatePageCount()
	
}

enum State {
	case main
	case search
}

final class MainViewModel: MainViewModelProtocol {
	
	private var photoList: [Photo] = []
	private var foundPhotoList: [Photo] = []
	
	private var state: State = .main
	private var pageCount = 1
	
	
	public func savePhotos(_ photoList: [Photo]) {
		if photoList.count == 0 {
			self.photoList = photoList
		} else {
			self.photoList.append(contentsOf: photoList)
		}
	}
	
	public func savefoundPhoto(_ foundPhotoList: [Photo]) {
		
		self.foundPhotoList = foundPhotoList
	}
	
	func numberOfItemsInSection() -> Int {
		
		switch state {
			
		case .main:
			
			return photoList.count
			
		case .search:
			
			return foundPhotoList.count
		}
	}
	
	func didSelectItemAt(_ indexPath: IndexPath) -> String {
		
		switch state {
			
		case .main:
			
			return photoList[indexPath.row].urls.full
			
		case .search:
			
			return foundPhotoList[indexPath.row].urls.full
		}
	}
	
	func cellForItemAt(_ indexPath: IndexPath) -> ImageCollectionViewCellViewModel {
		
		switch state {
			
		case .main:
			
			let photo = photoList[indexPath.row]
			
			let viewModel = getViewModelForCell(state: .main, photo: photo)
			
			return viewModel
			
		case .search:
			
			let photo = foundPhotoList[indexPath.row]
			
			let viewModel = getViewModelForCell(state: .search, photo: photo)
			
			return viewModel
		}
	}
	
	func noOfCellsInRow() -> Int {
		
		switch state {
			
		case .main:
			
			return 3
			
		case .search:
			
			return 1
		}
	}
	
	func removeItemAt(_ indexPath: IndexPath) {
		
		foundPhotoList.remove(at: indexPath.row)
	}

	
	public func getPageCount() -> Int {
		
		return pageCount
	}
	
	public func updatePageCount() {
		
		pageCount += 1
	}
	
	func getState() -> State {
		
		return state
	}
	
	func updateState(with state: State) {
		
		self.state = state
	}
}

private extension MainViewModel {
	
	func getViewModelForCell(state: State, photo: Photo) -> ImageCollectionViewCellViewModel {
		
		let viewModel = ImageCollectionViewCellViewModel(state: state, id: photo.id, smallUrl: photo.urls.small, fullUrl: photo.urls.full)
		
		return viewModel
	}
}
