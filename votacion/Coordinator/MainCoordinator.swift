//
//  votacion
//
//  Created by miguel tomairo on 25/06/22.
//

import Foundation
import UIKit
import Alamofire

class MainCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func home() {
        let vc = HomeViewController.instantiate(StoryboardIdentifiers.Home)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func listBreeds(_ breeds: Breeds) {
        let vc = BreedsViewController.instantiate(StoryboardIdentifiers.Breeds)
        vc.coordinator = self
        vc.arr = breeds
        navigationController.pushViewController(vc, animated: true)
    }
    
    func breedDetail(breed: Breed) {
        let vc = DetailViewController.instantiate(StoryboardIdentifiers.Detail)
        vc.coordinator = self
        vc.breed = breed
        navigationController.pushViewController(vc, animated: true)

    }
    
    func showVotes(_ votes: Breeds) {
        let vc = VoteViewController.instantiate(StoryboardIdentifiers.Vote)
        vc.coordinator = self
        vc.votes = votes
        navigationController.pushViewController(vc, animated: true)
    }
}
