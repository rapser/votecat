//
//  DetailViewController.swift
//  votacion
//
//  Created by miguel tomairo on 26/06/22.
//

import UIKit

class DetailViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    weak var coordinator: MainCoordinator?
    
    var breed: Breed?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Detalle"
        configure()
    }
    
    func configure() {
        
        titleLabel.text = breed?.name
        countryLabel.text = breed?.origin
        descriptionLabel.text = breed?.description        
        photoImage.layer.cornerRadius = 8.0
        
        guard let imageUrl = breed?.image?.url else {return}
        photoImage.sd_setImage(with: URL(string: imageUrl))
    }
    
}
