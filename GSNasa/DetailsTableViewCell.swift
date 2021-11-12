//
//  DetailsTableViewCell.swift
//  GSNasa
//
//  Created by Manjunath Kambalekar on 02/10/21.
//

import UIKit

/**
    This cell class is responsible for the displaying of favorited images.
*/

class DetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var detailsImageView:UIImageView!
    @IBOutlet weak var mediaTypeImageView:UIImageView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var heartButton:UIButton!
    
    var unfavoriteAction:((Media,Int) ->  Void)?
    var showDetailsMedia:((_ data: Media) -> Void)?
    var index:Int = 0
    var details:Media?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func heartButtonTapped(_ sender:Any) {
        if let action = unfavoriteAction, let mediaDetails = details {
            action(mediaDetails, index)
        }
    }
    
    /**
        This function populates the data
    */

    func config(detail:Media) {
        self.details = detail
        if let mediaDetails = details, let imageData = mediaDetails.image.image,
           let image = UIImage(data:imageData, scale:1.0) {
            detailsImageView.image = image//Helper.getThumbnail(image: image)
            titleLabel.text = mediaDetails.details.title
            dateLabel.text = mediaDetails.details.date
            mediaTypeImageView.isHidden = true
        }
    }

}
