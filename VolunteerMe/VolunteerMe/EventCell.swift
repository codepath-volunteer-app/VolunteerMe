//
//  EventCell.swift
//  VolunteerMe
//
//  Created by ruthie_berman on 10/21/17.
//  Copyright © 2017 volunteer_me. All rights reserved.
//

import UIKit
import AFNetworking

class EventCell: UITableViewCell {
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var time: UILabel!
    
    var event: Event? {
        didSet {
            title.text = event!.name
            descriptionLabel.text = event!.eventDescription
            time.text = "\(event!.humanReadableDateString!) at \(event!.humanReadableTimeString!)"
            if let imageUrlString = event!.imageUrl {
                let imageUrl = URL(string: imageUrlString)
                eventImage.setImageWith(imageUrl!)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Color.WHITE
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
