//
//  HomeViewModel.swift
//  votacion
//
//  Created by miguel tomairo on 26/06/22.
//

import Foundation
import Alamofire
import IHProgressHUD

class HomeViewModel {
    
    // MARK: - Properties
    private var breeds: Breeds? {
        didSet {
            guard let k = breeds else { return }
            self.setupText(with: k.count)
            didFinish?(k)
        }
    }
    
    private var breed: Breed? {
        didSet {
            guard let k = breed else { return }
            didFinishBreed?(k)
        }
    }

    var error: CustomError? {
        didSet { self.showAlertClosure?() }
    }
    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }

    private var dataService: DataService?

    // MARK: - Closures for callback
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinish: ((_ arr: Breeds) -> ())?
    var didFinishBreed: ((_ breed: Breed) -> ())?

    // MARK: - Constructor
    init(dataService: DataService) {
       self.dataService = dataService
    }

    // MARK: - Network call
    
    func getListBreeds() {
        
        IHProgressHUD.show()
        self.dataService?.requestListBreeds({ result in
            switch result {
            case .success(let data):
                do {
                    let entity = try JSONDecoder().decode(Breeds.self, from: data)
                    self.error = nil
                    self.isLoading = false
                    self.breeds = entity
                } catch let err{
                    print(err.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        })
    }
    
    func getBreedById(_ id: String) {
        
        IHProgressHUD.show()
        self.dataService?.requestBreedById(id: id, { result in
            switch result {
            case .success(let data):
                do {
                    let entity = try JSONDecoder().decode(Breed.self, from: data)
                    self.error = nil
                    self.isLoading = false
                    self.breed = entity
                } catch let err{
                    print(err.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })

    }

    private func setupText(with id: Int?) {
        guard let id = id else {return}
        print("texto: \(id)")
    }
}

