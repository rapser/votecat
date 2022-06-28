//
//  votacion
//
//  Created by miguel tomairo on 25/06/22.
//

import Foundation
import Alamofire

enum CustomError: Error {
    case unAuthorized(Data?)
    case notFound(Data?)
    case locked(Data?)
    case unavailableServer(Data?)
    case badRequest(Data?)
    case conflict(Data?)
    case unProcessable
    case serverError
}

enum LookupError: Error {
    case InvalidName
    case NullData
    case InvalidPhone
}
