//
//  BreedTableViewCell.swift
//  votacion
//
//  Created by miguel tomairo on 27/06/22.
//

import UIKit
import SDWebImage

class VoteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var voteImage: UIImageView!

    
    func configure(breed: Breed) {
        
        titleLabel.text = breed.name
        dateLabel.text = breed.date
        photoImage.layer.cornerRadius = 8.0
        guard let imageUrl = breed.image?.url, let vote = breed.vote else {return}
        photoImage.sd_setImage(with: URL(string: imageUrl))
        
        if vote == .like {
            voteImage.image = UIImage(named: "card-like")!
        }else {
            voteImage.image = UIImage(named: "card-deslike")!
        }
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
