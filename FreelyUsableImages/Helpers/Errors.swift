//
//  Errors.swift
//  FreelyUsableImages
//
//  Created by Evgeniy Opryshko on 20.07.2020.
//  Copyright © 2020 Evgeniy Opryshko. All rights reserved.
//

import Foundation

enum NetworkRequestError: Error {
    case unknown(Data?, URLResponse?)
}

extension NetworkRequestError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unknown(_, let response):
			return NSLocalizedString("Unknown Response", comment: "\(response.debugDescription)")
        }
    }
}

enum JSONDecoderError: Error {
	case parseError
	case dataIsNil
}

extension JSONDecoderError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .parseError:
            return NSLocalizedString("The data couldn’t be read because it isn’t in the correct format.", comment: "")
		case .dataIsNil:
			return NSLocalizedString("The data is nil", comment: "")
        }
    }
}
