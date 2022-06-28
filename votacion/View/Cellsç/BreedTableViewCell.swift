//
//  BreedTableViewCell.swift
//  votacion
//
//  Created by miguel tomairo on 27/06/22.
//

import UIKit
import SDWebImage

class BreedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    func configure(breed: Breed) {
        
        titleLabel.text = breed.name
        descriptionLabel.text = breed.origin
        photoImage.layer.cornerRadius = 8.0
        guard let imageUrl = breed.image?.url else {return}
        photoImage.sd_setImage(with: URL(string: imageUrl))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
