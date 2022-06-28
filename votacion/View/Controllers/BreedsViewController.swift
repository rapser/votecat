//
//  BreedsViewController.swift
//  votacion
//
//  Created by miguel tomairo on 26/06/22.
//

import UIKit

class BreedsViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var coordinator: MainCoordinator?
    
    var arr: Breeds = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Razas"
        
        configure()
    }
    
    func configure() {
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
}

extension BreedsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BreedTableViewCell", for: indexPath) as! BreedTableViewCell
        
        let breed = arr[indexPath.row]
        cell.configure(breed: breed)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBreed = arr[indexPath.row]
        coordinator?.breedDetail(breed: selectedBreed)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
}
