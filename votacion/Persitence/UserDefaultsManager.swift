//
//  votacion
//
//  Created by miguel tomairo on 25/06/22.
//

import Foundation

class UserDefaultsManager {
    enum Key: String {
        case apiKey
        case secretKey
        case token
        case isSignedIn
        case refreshToken
        case breeds
    }
    static let shared: UserDefaultsManager = {
        return UserDefaultsManager()
    }()
    
    func setBreeds(_ arr: Breeds) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(arr), forKey: Key.breeds.rawValue)
    }
    
    func getBreeds() -> Breeds? {
        var breeds: Breeds?
        if let data = UserDefaults.standard.value(forKey: Key.breeds.rawValue) as? Data {
            let votes = try? PropertyListDecoder().decode(Breeds.self, from: data)
            breeds = votes
        }
        return breeds
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: Key.token.rawValue)
    }
    func setToken(token: String) {
        UserDefaults.standard.set(token, forKey: Key.token.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    func getRefreshToken() -> String? {
        return UserDefaults.standard.string(forKey: Key.refreshToken.rawValue)
    }
    func setRefreshToken(token: String) {
        UserDefaults.standard.set(token, forKey: Key.refreshToken.rawValue)
        UserDefaults.standard.synchronize()
    }
    
}
