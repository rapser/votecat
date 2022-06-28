//
//  ViewController.swift
//  votacion
//
//  Created by miguel tomairo on 25/06/22.
//

import Foundation

enum Endpoint {
    case refreshToken
    case listBreeds
    case breed(id: String)
}

extension Endpoint {
    var url: URL {
        switch self {
        case .refreshToken:
            return .makeForEndpoint("REFRESH_TOKEN_URL")
        case .listBreeds:
            return .makeForEndpoint("breeds?limit=20&page=0")
        case .breed(id: let id):
            return .makeForEndpoint("breeds/\(id)")
        }
    }
}

extension URL {
    static var onboarding: URL {
        makeForEndpoint("benefits")
    }
}

private extension URL {
    static func makeForEndpoint(_ endpoint: String) -> URL {
        URL(string: Constants.baseURL + endpoint)!
    }
}
