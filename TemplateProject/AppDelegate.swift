//
//  AppDelegate.swift
//  Template Project
//
//  Created by Benjamin Encz on 5/15/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

//spacing is retarded but whatever

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
        
        parseLoginHelper = ParseLoginHelper { [unowned self] user, error in
            //initialize parse login error with callback
            if let error = error {
                ErrorHandling.defaultErrorHandler(error)
            } else if let user = user {
             //if login was successful show the map
                let storyboard = UIStoryBoard(name: "Main", bundle: nil)
                let mapViewController = storyboard.instantiateViewController("MapViewController") as! UIViewController
                self.window?.rootViewController!.presentViewController(mapViewController, animated: true, completion: nil)
            }
        }
    }
    


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    //set up Parse SDK
    Post.registerSubclass()
    Parse.setApplicationId("GWBnyQuwxythsZwR16EWZZjdm0ziLxcBLx6a8qlw", clientKey: "BPmTkqE73RBdestq0UCUXUpq2OmdEUf94eTiTjBm")
    
    //initialize Facebook
    PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
    
    //checks if user is logged in
    let user = PFUser.currentUser()
    
    let startViewController: UIViewController
    
    if user != nil {
        //if user exists, set the MapViewController to be initial 
        
    }
    
    return true
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

