//
//  FullPostviewController.swift
//  i_am_here
//
//  Created by Edward Yoo on 7/24/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import UIKit
import Parse

class FullPostViewController: UIViewController {


    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var dateString: String?
    var postCreatedDate: String?
    
    var wholePost: Post? {
        didSet {
            displayPost(wholePost)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        displayPost(wholePost)
    }
    
    func displayPost(post: Post?) {
        if let post = post, postTextLabel = postTextLabel, displayNameLabel = displayNameLabel {
            displayNameLabel.text = post.displayName
            postTextLabel.text = post.text
            dateLabel.text = dateToString(post.createdAt!)
        }
    }
    
    func dateToString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy 'at' HH:mm"
        dateString = dateFormatter.stringFromDate(date)
        return dateString!
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
