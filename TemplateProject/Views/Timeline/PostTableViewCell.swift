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
    @IBOutlet weak var postDateLabel: UILabel!
    var dateString: String?

    
    var wholePost: Post? {
        didSet {
            self.backgroundColor = StyleConstants.beigeColor
            displayPost(wholePost!)
        }
    }
    
    func displayPost(post: Post?) {
        if let post = post, postTextLabel = postTextLabel, displayNameLabel = displayNameLabel, postDateLabel = postDateLabel {
            displayNameLabel.text = post.displayName
            postTextLabel.text = post.text
            postDateLabel.text = dateToString(post.createdAt!)
        }
    }
    
    func dateToString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy 'at' HH:mm"
        dateString = dateFormatter.stringFromDate(date)
        return dateString!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
