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
            eventTimeLabel.text = event.humanReadableTimeRange
            
            if let imageUrlString = event.imageUrl {
                let imageUrl = URL(string: imageUrlString)
                profileImage.setImageWith(imageUrl!)
            }

            if let tags = event.tags {
                let tagNames: [String] = tags.map({ (tag: Tag) -> String? in
                    return tag.name
                }).filter({ (tagName: String?) -> Bool in
                    return tagName != nil
                }).map({ (tagName: String?) -> String in
                    return tagName!
                })
                
                let listOfTagNames = tagNames.joined(separator: ", ")
                
                tagsLabel.text = "Tags: \(listOfTagNames)"
            }
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
