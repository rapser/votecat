//
//  votacion
//
//  Created by miguel tomairo on 25/06/22.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] {get set}
    var navigationController: UINavigationController {get set}
}

