//
//  votacion
//
//  Created by miguel tomairo on 25/06/22.
//

import Foundation
import UIKit

protocol Storyboarded {
    
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    
    static func instantiate() -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: "Home", bundle: Bundle.main)
        
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
    
    static func instantiate(_ sb: String) -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: sb, bundle: Bundle.main)
        
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
