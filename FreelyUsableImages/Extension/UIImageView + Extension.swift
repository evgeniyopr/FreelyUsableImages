//
//  UIImageView + Extension.swift
//  FreelyUsableImages
//
//  Created by Evgeniy Opryshko on 21.07.2020.
//  Copyright © 2020 Evgeniy Opryshko. All rights reserved.
//

import UIKit

extension UIImageView {
	
	func load(url: URL, completion: @escaping ()->()) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
						completion()
                    }
                }
            }
        }
    }
}
