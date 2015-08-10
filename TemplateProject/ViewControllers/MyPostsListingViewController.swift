//
//  MyPostsListingViewController.swift
//  i_am_here
//
//  Created by Edward Yoo on 7/25/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

class MyPostsListingViewController: UITableViewController {
    
    var posts: [Post] = []
    var selectedPost: Post?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let postsQuery = Post.query()
        postsQuery!.orderByDescending("createdAt")
        postsQuery!.whereKey("user", equalTo: PFUser.currentUser()!)
        postsQuery!.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
            self.posts = result as? [Post] ?? []
            self.tableView.reloadData()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showFullPostFromUser" {
            let fullPostViewController = segue.destinationViewController as! FullPostViewController
            fullPostViewController.wholePost = selectedPost
        }
    }

}

extension MyPostsListingViewController: UITableViewDataSource, UITableViewDelegate {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedPost = posts[indexPath.row]
        self.performSegueWithIdentifier("showFullPostFromUser", sender: self)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //dynamic rows
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! UserPostTableViewCell
        
        let postAtIndex = posts[indexPath.row] as Post
        cell.wholePost = postAtIndex
        
        return cell
    }
    
}
