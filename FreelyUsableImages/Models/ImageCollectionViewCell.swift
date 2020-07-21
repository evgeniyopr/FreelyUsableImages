//
//  ImageCollectionViewCell.swift
//  FreelyUsableImages
//
//  Created by Evgeniy Opryshko on 20.07.2020.
//  Copyright © 2020 Evgeniy Opryshko. All rights reserved.
//

import UIKit

struct ImageCollectionViewCellViewModel {
	
	let state: State
	
	let id: String
	let smallUrl: String
	let fullUrl: String
}

protocol ImageCollectionViewCellDelegate: AnyObject {
	
	func didTouchDelete(cell: UICollectionViewCell)
}

class ImageCollectionViewCell: UICollectionViewCell {
	
	//MARK: - IBOutlet
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var deleteButton: UIButton!
	
	// MARK: - Public Properties
	
	weak var delegate: ImageCollectionViewCellDelegate!
	
	// MARK: - Life Cycle
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func prepareForReuse() {
		imageView.image = nil
	}
	
	func configure(with viewModel: ImageCollectionViewCellViewModel) {
		
		if let url = URL(string: viewModel.smallUrl) {
			self.imageView.load(url: url)
		} else {
			imageView.backgroundColor = .gray
		}
		
		if viewModel.state == .main {
			deleteButton.isHidden = true
		} else {
			deleteButton.isHidden = false
		}
	}
}

//MARK: - IBAction

extension ImageCollectionViewCell {
	
	@IBAction func didTouchDelete(_ sender: Any) {
		delegate?.didTouchDelete(cell: self)
	}
}
