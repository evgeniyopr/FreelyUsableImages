//
//  NetworkService.swift
//  FreelyUsableImages
//
//  Created by Evgeniy Opryshko on 20.07.2020.
//  Copyright © 2020 Evgeniy Opryshko. All rights reserved.
//

import Foundation

protocol NetworkingProtocol {
	func request(path: String, parameters: [String: String], completion: @escaping (Result<Data, Error>) -> ())
}

final class NetworkService: NetworkingProtocol {
	
	func request(path: String, parameters: [String: String], completion: @escaping (Result<Data, Error>) -> ()) {
		let url = self.url(from: path, parameters: parameters)
		print(url)
		let request = URLRequest(url: url)
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let responseData = data, error == nil else {
				completion(.failure(error ?? NetworkRequestError.unknown(data, response)))
				return
			}
			completion(.success(responseData))
		}
		task.resume()
	}
	
	private func url(from path: String, parameters: [String: String]) -> URL {
		var components = URLComponents()
		components.scheme = API.scheme
		components.host = API.host
		components.path = path
		components.queryItems = parameters.map {  URLQueryItem(name: $0, value: $1) }
		return components.url!
	}
}
