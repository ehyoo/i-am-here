//
//  MyAccountViewController.swift
//  i_am_here
//
//  Created by Edward Yoo on 7/24/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseUI

class MyAccountViewController: UIViewController {
    
    let loginViewController = PFLogInViewController()
    var parseLoginHelper: ParseLoginHelper!
    var posts: [Post] = []
    var postCount: Int = 0
    
    @IBOutlet weak var postCountLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queryForUser()
    }
    
    override func viewDidAppear(animated: Bool) {
        queryForUser()
    }
    
    func queryForUser() {
        
        let postsQuery = Post.query()
        postsQuery!.orderByDescending("createdAt")
        postsQuery!.whereKey("user", equalTo: PFUser.currentUser()!)
        postsQuery!.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
            self.posts = result as? [Post] ?? []
            self.postCount = self.posts.count
            if self.posts.count == 0 {
                self.postCountLabel.text = "You have made no posts yet!"
            } else if self.posts.count == 1 {
                self.postCountLabel.text = "You have made 1 post!"
            } else {
                self.postCountLabel.text = "You have made \(self.postCount) posts!"
            }
        }
        nameLabel.text = "Hello, \(PFUser.currentUser()!.username!)!"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.logOut()
        //FIGURE OUT HOW TO FIX THE LOGIN SCREEN SEGUE AND STUFF
        //MAN YOU'RE BAD AT THIS
    }
    
}
