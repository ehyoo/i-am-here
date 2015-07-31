//
//  PostTableWithImageViewCell.swift
//  i_am_here
//
//  Created by Edward Yoo on 7/31/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import UIKit
import Parse

class PostTableWithImageViewCell: UITableViewCell {
    
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var displayPostLabel: UILabel!
    @IBOutlet weak var displayDateLabel: UILabel!
    @IBOutlet weak var displayImageView: UIImageView!
    var dateString: String?
    
    var wholePost: Post? {
        didSet {
            displayPost(wholePost!)
        }
    }
    
    func displayPost(post: Post?) {
        if let post = post, displayPostLabel = displayPostLabel, displayNameLabel = displayNameLabel, displayDateLabel = displayDateLabel, displayImageView = displayImageView {
            displayNameLabel.text = post.displayName
            displayPostLabel.text = post.text
            displayDateLabel.text = dateToString(post.createdAt!)
            displayImageView.image = imageConverter(post.imageFile)
        }
    }
    
    func dateToString(date: NSDate) -> String {
        //converts date to string
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy 'at' HH:mm"
        dateString = dateFormatter.stringFromDate(date)
        return dateString!
    }
    
    func imageConverter(file: PFFile) -> UIImage {
        let data = file.getData()
        var viewImage = UIImage(data: data!, scale: 1.0)
        return viewImage!
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