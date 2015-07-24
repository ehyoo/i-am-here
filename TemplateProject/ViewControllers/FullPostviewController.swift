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
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
