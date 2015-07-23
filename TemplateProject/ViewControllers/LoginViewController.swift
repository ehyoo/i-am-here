//
//  LoginViewController.swift
//  i_am_here
//
//  Created by Edward Yoo on 7/21/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class LogInViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    var logInViewController: PFLogInViewController = PFLogInViewController()
    var signUpViewController: PFSignUpViewController! = PFSignUpViewController()
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,150,150)) as UIActivityIndicatorView
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(PFUser.currentUser())
        
        //i have no idea what an UIActivityIndicatorView is
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(actInd)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if PFUser.currentUser() == nil {
            var signUpLogoTitle = UILabel()
            signUpLogoTitle.text = "i am here"
            self.signUpViewController.signUpView!.logo = signUpLogoTitle
            
            self.signUpViewController.delegate = self
            self.logInViewController.signUpController = self.signUpViewController
        }
    }
    
    // MARK: Parse Login
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        //something
        if (!username.isEmpty || !password.isEmpty) {
            return true
        } else {
            return false
        }
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        //something
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        //something
        println("failed to login")
    }
    
    // MARK: Parse Signup
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        //something
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        //something
        println("user failed to sign up")
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        //something
        println("user dismissed signup")
    }
 
    // MARK: Actions 
    @IBAction func registerAction(sender: AnyObject) {
        self.presentViewController(self.signUpViewController, animated: true, completion: nil)
    }
    @IBAction func signInAction(sender: AnyObject) {
        var username = self.usernameField.text
        var password = self.passwordField.text
        //you should implement a sanity check for the number of characters per password
        self.actInd.startAnimating()
        PFUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
            self.actInd.stopAnimating()
            
            if user != nil {
                self.performSegueWithIdentifier("toMapView", sender: self)
                
                var alert = UIAlertView(title: "Success", message: "Logged in", delegate: self, cancelButtonTitle: "Great")
                alert.show()
            } else {
              var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
            }
        })
    }
    
}
