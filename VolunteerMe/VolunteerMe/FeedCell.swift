//
//  FeedCell.swift
//  VolunteerMe
//
//  Created by Rajat Bhargava on 10/11/17.
//  Copyright © 2017 volunteer_me. All rights reserved.
//

import UIKit
import AFNetworking

class FeedCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var feedTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var feedDescriptionLabel: UILabel!
    
    var event: Event! {
        didSet{
            feedDescriptionLabel.text = event.eventDescription
            dateLabel.text = event.humanReadableDateString
            feedTitleLabel.text = event.name
            
            if let imageUrlString = event.imageUrl {
                let imageUrl = URL(string: imageUrlString)
                profileImage.setImageWith(imageUrl!)
            }
            tagsLabel.text = "Tags: "
//            if let tags = event.tags {
//                for tag in tags {
//                    if let tagName = tag.name {
//                        tagsLabel.text! += "\(tagName)"
//                    }
//                }
//            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImage.layer.cornerRadius = 5
        profileImage.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
