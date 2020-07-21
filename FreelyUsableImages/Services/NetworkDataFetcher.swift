//
//  NetworkService.swift
//  FreelyUsableImages
//
//  Created by Evgeniy Opryshko on 20.07.2020.
//  Copyright © 2020 Evgeniy Opryshko. All rights reserved.
//

import Foundation

protocol DataFetcherProtocol {
	
	func fetchPhotos(page: Int, completion: @escaping (Result<[Photo], Error>) -> Void)
	func searchPhotoBy(name: String, completion: @escaping (Result<SearchResult, Error>) -> Void)
}

class NetworkDataFetcher: DataFetcherProtocol {
	
	let networking: NetworkingProtocol
	
	init(networking: NetworkingProtocol) {
		self.networking = networking
	}

	func fetchPhotos(page: Int, completion: @escaping (Result<[Photo], Error>) -> Void) {
		
		let parameters = [Constants.clientId: API.apiKey,
						  Constants.page: String(page),
						  Constants.perPage: "30"]
		
		networking.request(path: API.photos, parameters: parameters) { result in
			
			switch result {
				
			case .success(let data):
				
				let decoded = self.decodeJSON(type: [Photo].self, from: data)
				completion(decoded)
				
			case .failure(let error):
				
				completion(.failure(error))
			}
		}
	}
	
	func searchPhotoBy(name: String, completion: @escaping (Result<SearchResult, Error>) -> Void) {
		
		let parameters = [Constants.clientId: API.apiKey,
		Constants.page: "1",
		Constants.perPage: "30",
		Constants.query: name,
		Constants.orientation: "landscape"]
		
		networking.request(path: API.searchPhotos, parameters: parameters) { result in
			
			switch result {
				
			case .success(let data):
				
				let decoded = self.decodeJSON(type: SearchResult.self, from: data)
				completion(decoded)
				
			case .failure(let error):
				
				completion(.failure(error))
			}
		}
	}
	
	private func decodeJSON<T: Decodable>(type: T.Type, from data: Data?) -> Result<T, Error> {
		
		guard let data = data else { return .failure(JSONDecoderError.dataIsNil) }
		
		let decoder = JSONDecoder()
		
		do {
			let response = try decoder.decode(type.self, from: data)
			return .success(response)
		} catch let error {
			return .failure(error)
		}
	}
}
