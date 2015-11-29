//
//  AppDelegate.swift
//  Template Project
//
//  Created by Benjamin Encz on 5/15/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//


import UIKit
import Parse
import FBSDKCoreKit
import ParseUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var parseLoginHelper: ParseLoginHelper!
    
    override init() {
        super.init()
        
        parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
            // Initialize the ParseLoginHelper with a callback
            if let error = error {
                
                ErrorHandling.defaultErrorHandler(error)
                
            } else  if let user = user {
                // if login was successful, display the TabBarController
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let tabController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UIViewController
                // 3
                if self.window?.rootViewController!.presentedViewController == nil {
                    self.window?.rootViewController!.presentViewController(tabController, animated:true, completion:nil)
                } else {
                    self.window?.rootViewController!.dismissViewControllerAnimated(true, completion: {
                        self.window?.rootViewController!.presentViewController(tabController, animated:true, completion:nil)
                    })
                }

            }
        }
    }
    


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    //esign for app
    UINavigationBar.appearance().barTintColor = StyleConstants.customGreenColor
    UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    UITabBar.appearance().barTintColor = StyleConstants.customGreenColor
    UITabBar.appearance().tintColor = UIColor.whiteColor()
    
    //set up Parse SDK
    Post.registerSubclass()
    Parse.setApplicationId("GWBnyQuwxythsZwR16EWZZjdm0ziLxcBLx6a8qlw", clientKey: "BPmTkqE73RBdestq0UCUXUpq2OmdEUf94eTiTjBm")
    
    // Initialize Facebook
    PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
    
    // check if we have logged in user
    let user = PFUser.currentUser()
    
    let startViewController: UIViewController;
    
    if (user != nil) {

        // if we have a user, set the TabBarController to be the initial View Controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        startViewController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
    } else {

        // Otherwise set the LoginViewController to be the first
        let loginViewController = PFLogInViewController()
        let signUpViewController = PFSignUpViewController()
        loginViewController.fields = .UsernameAndPassword | .LogInButton | .SignUpButton | .PasswordForgotten | .Facebook
        
        //login and sign up screen logo
        
        var logoImage: UIImageView
        logoImage = UIImageView(frame:CGRectMake(0, 0, 300, 150))
        logoImage.image = UIImage(named:"LogoHorizontal")
        logoImage.contentMode = UIViewContentMode.ScaleAspectFit
        loginViewController.logInView!.logo = logoImage
        
        var signUpImage: UIImageView
        signUpImage = UIImageView(frame:CGRectMake(0, 0, 300, 150))
        signUpImage.image = UIImage(named:"LogoHorizontal")
        signUpImage.contentMode = UIViewContentMode.ScaleAspectFit
        
        
        signUpViewController.signUpView!.logo = signUpImage
        
        
        //delegation and stuff
        loginViewController.delegate = parseLoginHelper
        signUpViewController.delegate = parseLoginHelper
        
        startViewController = loginViewController
        loginViewController.signUpController = signUpViewController
    }
    
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    self.window?.rootViewController = startViewController;
    self.window?.makeKeyAndVisible()
    
    return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    //log out
    
    func logOut() {
        PFUser.logOut()
        var showedViewController: UIViewController
        
        let loginViewController = PFLogInViewController()
        let signUpViewController = PFSignUpViewController()
        
        loginViewController.fields = .UsernameAndPassword | .LogInButton | .SignUpButton | .PasswordForgotten | .Facebook
        loginViewController.delegate = parseLoginHelper
        signUpViewController.delegate = parseLoginHelper
        
        //design for login screen logo
        
        var logoImage: UIImageView
        logoImage = UIImageView(frame:CGRectMake(0, 0, 300, 150))
        logoImage.image = UIImage(named:"LogoHorizontal")
        logoImage.contentMode = UIViewContentMode.ScaleAspectFit
        
        showedViewController = loginViewController
        
        loginViewController.logInView!.logo = logoImage
        
        var signUpImage: UIImageView
        signUpImage = UIImageView(frame:CGRectMake(0, 0, 300, 150))
        signUpImage.image = UIImage(named:"LogoHorizontal")
        signUpImage.contentMode = UIViewContentMode.ScaleAspectFit
        
        signUpViewController.signUpView!.logo = signUpImage
        
        
        loginViewController.signUpController = signUpViewController
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = showedViewController;
        self.window?.makeKeyAndVisible()
        
    }
    
  //MARK: Facebook Integration
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

