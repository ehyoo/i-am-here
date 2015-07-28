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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.logOut()
        //we leave off here
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
