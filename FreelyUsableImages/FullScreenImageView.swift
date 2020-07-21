//
//  FullScreenImageView.swift
//  FreelyUsableImages
//
//  Created by Evgeniy Opryshko on 21.07.2020.
//  Copyright © 2020 Evgeniy Opryshko. All rights reserved.
//

import UIKit

class FullScreenImageView: UIView {
	
	let activityView = UIActivityIndicatorView(style: .large)
	let imageView = UIImageView()
	
	init(url: URL) {
		self.init()
		
		fetchImageBy(url: url)
		
		activityView.hidesWhenStopped = true
		showActivityIndicatory()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func fetchImageBy(url: URL) {
		
		imageView.frame = UIScreen.main.bounds
		imageView.backgroundColor = .black
		imageView.contentMode = .scaleAspectFit
		imageView.isUserInteractionEnabled = true
		
		imageView.load(url: url) { [weak self] in
			self?.hideActivityIndicatory()
		}
		
		self.addSubview(imageView)
	}
	
	private func showActivityIndicatory() {
		
		activityView.center = self.imageView.center
		self.imageView.addSubview(activityView)
		activityView.startAnimating()
	}
	
	private func hideActivityIndicatory() {
		activityView.stopAnimating()
	}
}
