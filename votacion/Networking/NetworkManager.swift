//
//  votacion
//
//  Created by miguel tomairo on 25/06/22.
//

import Alamofire
import Foundation
import SwiftyJSON

class NetworkManager {
    static let shared: NetworkManager = {
        return NetworkManager()
    }()
    typealias completionHandler = ((Result<Data, CustomError>) -> Void)
    typealias completionHandler2 = ((Result<Void, CustomError>) -> Void)
            
    var request: Alamofire.Request?
    let retryLimit = 2
    
    let headers: HTTPHeaders = ["x-api-key":"klsdkldskldskl"]
    
    // MARK: - Public
    
    func request(_ url: String, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.queryString, completion: @escaping completionHandler) {
        
        
        request?.cancel()
        request = AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).validate(statusCode: 200..<300).responseJSON { response in
            
            self.logEndpoint(url, parameters ?? [:], response: response)
            
            switch response.result {
            case .success:
                if let data = response.data {
                    completion(.success(data))
                }
            case .failure(let error):
                print(error.localizedDescription)
                switch response.response?.statusCode {
                case 400:
                    completion(.failure(.badRequest(response.data)))
                case 401:
                    completion(.failure(.unAuthorized(response.data)))
                case 404:
                    completion(.failure(.notFound(response.data)))
                case 409:
                    completion(.failure(.conflict(response.data)))
                case 422:
                    completion(.failure(.unProcessable))
                case 423:
                    completion(.failure(.locked(response.data)))
                case 500:
                    completion(.failure(.serverError))
                default:
                    completion(.failure(.serverError))
                }
            }
        }
    }
    
    // MARK: - Oauth
    
    func requestOauth(_ url: String, method: HTTPMethod = .get, parameters: Parameters? = nil,
                 encoding: ParameterEncoding = URLEncoding.queryString, headers: HTTPHeaders? = nil,
                 interceptor: RequestInterceptor? = nil, completion: @escaping completionHandler) {
        
        AF.request(url, method: method, parameters: parameters, encoding: encoding,
                   headers: headers, interceptor: interceptor ?? self).validate(statusCode: 200..<300).responseJSON { (response) in
                    
            self.logEndpoint(url, parameters ?? [:], response: response)
                    
            switch response.result {
            case .success:
                if let data = response.data {
                    completion(.success(data))
                }
            case .failure(let error):
                print(error.localizedDescription)
                switch response.response?.statusCode {
                case 400:
                    completion(.failure(.badRequest(response.data)))
                case 404:
                    completion(.failure(.notFound(response.data)))
                case 401:
                    completion(.failure(.unAuthorized(response.data)))
                case 409:
                    completion(.failure(.conflict(response.data)))
                case 423:
                    completion(.failure(.locked(response.data)))
                case 500:
                    completion(.failure(.serverError))
                default:
                    completion(.failure(.serverError))
                }
            }
        }
    }
    
    // TODO: Response Void
    
    func request2(_ url: String, method: HTTPMethod = .get, parameters: Parameters? = nil,
                 encoding: ParameterEncoding = URLEncoding.queryString, headers: HTTPHeaders? = nil,
                 interceptor: RequestInterceptor? = nil, completion: @escaping completionHandler2) {
        
        AF.request(url, method: method, parameters: parameters, encoding: encoding,
                   headers: headers, interceptor: interceptor ?? self).validate(statusCode: 200..<300).response { (response) in
                    
            self.logEndpoint(url, parameters ?? [:], response: response)
                    
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                print(error.localizedDescription)
                switch response.response?.statusCode {
                case 400:
                    completion(.failure(.badRequest(response.data)))
                case 404:
                    completion(.failure(.notFound(response.data)))
                case 401:
                    completion(.failure(.unAuthorized(response.data)))
                case 409:
                    completion(.failure(.conflict(response.data)))
                case 423:
                    completion(.failure(.locked(response.data)))
                case 500:
                    completion(.failure(.serverError))
                default:
                    completion(.failure(.serverError))
                }
            }
        }
    }
    
    // MARK: - Logs
    
    func logEndpoint<T>(_ url: String,_ params: Parameters, response: AFDataResponse<T>) {
        
        if let code = response.response?.statusCode,
            let data = response.data,
            let json = try? JSON.init(data: data) {

            print("url: \(url)")
            print("param: \(String(describing: params))")
            print("statusCode: \(code)")
            print("response: \(json)")
        }
    }
}

