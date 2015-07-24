//
//  PostTableViewCell.swift
//  i_am_here
//
//  Created by Edward Yoo on 7/14/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import UIKit
import Parse

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var displayNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
