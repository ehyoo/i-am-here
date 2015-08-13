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

    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextLabel: UITextView!
    @IBOutlet weak var verticalLayout: NSLayoutConstraint!
    @IBOutlet weak var postImageViewHeight: NSLayoutConstraint!
    
    let regionRadius: CLLocationDistance = 250
    var dateString: String?
    var postCreatedDate: String?
    
    var wholePost: Post? {
        didSet {
            displayPost(wholePost)
        }
    }
    
    override func viewDidLoad() {
        println(postImageView.image)
        println(postImageView)
        
        postTextLabel.sizeToFit()
        postTextLabel.layoutIfNeeded()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        if postImageView.image == nil {
            println("image is nil")
        }
        
        //scroll to the top of the text view
        //we can delete this i think
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        displayPost(wholePost)
    }
    
    func displayPost(post: Post?) {
        if let post = post, postTextLabel = postTextLabel, displayNameLabel = displayNameLabel, postImageView = postImageView {
            displayNameLabel.text = post.displayName
            postTextLabel.text = post.text
            dateLabel.text = dateToString(post.createdAt!)
            
            if post.imageFile.getData() != nil {
                let data = post.imageFile.getData()
                var viewImage = UIImage(data: data!, scale: 1.0)
                
                postImageView.image = viewImage
                verticalLayout.constant = postImageView.frame.size.height + 8
                
            } else {
                postImageView.hidden = true
                
                //update constraints
                verticalLayout.constant = 16
            }
        }
    }
    
    func dateToString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy 'at' HH:mm"
        dateString = dateFormatter.stringFromDate(date)
        return dateString!
    }


}
