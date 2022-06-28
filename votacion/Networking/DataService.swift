//
//  ViewController.swift
//  votacion
//
//  Created by miguel tomairo on 25/06/22.
//

import Foundation
import Alamofire
import SwiftyJSON

struct DataService {
    
    static let shared = DataService()
    
    // MARK: - URL
    private var listBreeds = Endpoint.listBreeds.url
    
    typealias completionHandler = ((Result<Data, CustomError>) -> Void)

    func requestListBreeds(_ completion: @escaping completionHandler) {
                
        NetworkManager.shared.request(listBreeds.absoluteString, method: .get, encoding: JSONEncoding.default) { (result) in
            completion(result)
        }
        
    }
    
    func requestBreedById(id: String, _ completion: @escaping completionHandler) {
                
        let breed = Endpoint.breed(id: id).url

        NetworkManager.shared.request(breed.absoluteString, method: .get, encoding: JSONEncoding.default) { (result) in
            completion(result)
        }
        
    }
}

extension DataRequest {
    
    @discardableResult
    func responseLuqa<T: Codable>(queue: DispatchQueue? = nil, completionHandler: @escaping (AFDataResponse<T>) -> Void) -> Self {
        return responseDecodable(completionHandler: completionHandler)
    }
    
}
