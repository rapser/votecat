//
//  votacion
//
//  Created by miguel tomairo on 25/06/22.
//

import Alamofire
import Foundation

extension NetworkManager: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        guard let token = UserDefaultsManager.shared.getToken() else {
            completion(.success(urlRequest))
            return
        }
        let bearerToken = "Bearer \(token)"
        request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        print("\nadapted; token added to the header field is: \(bearerToken)\n")
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }

        refreshToken { result in
            switch result {
            case .success(let accessToken):
                print("token: \(accessToken)")
                completion(.retry)
            case .failure(let error):
                completion(.doNotRetryWithError(error))
            }
        }
    }
    
    func refreshToken(completion: @escaping (_ isSuccess: Result<String,Error>) -> Void) {
        guard let refresh = UserDefaultsManager.shared.getRefreshToken() else { return }
        let parameters = ["refreshToken": refresh]
        let refreshUrl = Endpoint.refreshToken.url
        AF.request(refreshUrl.absoluteString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
            case .success:
                if let data = response.data, let token = (try? JSONSerialization.jsonObject(with: data, options: [])
                    as? [String: Any])?["token"] as? String, let refreshToken = (try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any])?["refreshToken"] as? String {
                    UserDefaultsManager.shared.setToken(token: token)
                    UserDefaultsManager.shared.setRefreshToken(token: refreshToken)
                    print("\nRefresh token completed successfully. New token is: \(token)\n")
                    completion(.success(token))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
