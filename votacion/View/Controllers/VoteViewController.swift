//
//  VoteViewController.swift
//  votacion
//
//  Created by miguel tomairo on 28/06/22.
//

import UIKit

class VoteViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var coordinator: MainCoordinator?
    
    var votes: Breeds = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Votación"
        
        UserDefaultsManager.shared.setBreeds(votes)
        configure()
    }
    
    func configure() {
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension VoteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return votes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VoteTableViewCell", for: indexPath) as! VoteTableViewCell
        
        let vote = votes[indexPath.row]
        cell.configure(breed: vote)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
