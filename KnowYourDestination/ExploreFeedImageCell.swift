//
//  ExploreFeedImageCell.swift
//  KnowYourDestination
//
//  Created by Fernando on 7/17/17.
//  Copyright © 2017 Specialist. All rights reserved.
//

import UIKit

class ExploreFeedImageCell: UITableViewCell {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
