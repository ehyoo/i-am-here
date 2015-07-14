//
//  ListingViewController.swift
//  i_am_here
//
//  Created by Edward Yoo on 7/14/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

class ListingViewController: UIViewController {
    
    var posts: [Post] = []
    @IBOutlet weak var tableView: UITableView!
    let refPoint = PFGeoPoint(latitude: 40.7461608, longitude: -74.0064551) //hardcoded value for current location (MakeSchool)
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let postsQuery = Post.query()
        
        postsQuery!.orderByDescending("createdAt")
        
        postsQuery!.whereKey("location", nearGeoPoint: refPoint, withinMiles: 0.05) //geosearch
        
        postsQuery!.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
            self.posts = result as? [Post] ?? []
            self.tableView.reloadData()
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ListingViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! UITableViewCell
        
        cell.textLabel!.text = posts[indexPath.row].text
        
        return cell
    }
    
}



