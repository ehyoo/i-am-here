//
//  AboutPageViewController.swift
//  i_am_here
//
//  Created by Edward Yoo on 8/11/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//
//this is actually ridiculously annoying

import UIKit

class AboutPageViewController: UIViewController {


    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.sizeToFit()
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
