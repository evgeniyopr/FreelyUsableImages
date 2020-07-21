//
//  SearchResults.swift
//  FreelyUsableImages
//
//  Created by Evgeniy Opryshko on 21.07.2020.
//  Copyright © 2020 Evgeniy Opryshko. All rights reserved.
//

import Foundation

struct SearchResult: Decodable {
	let total: Int
	let total_pages: Int
	let results: [Photo]
}
