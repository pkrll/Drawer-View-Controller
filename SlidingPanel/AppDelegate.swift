//
//  AppDelegate.swift
//  SlidingPanel
//
//  Created by Ardalan Samimi on 24/03/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let mainViewController = storyboard.instantiateInitialViewController()!
    let leftViewController = storyboard.instantiateViewControllerWithIdentifier("LeftViewController")
    let slidingPanelController = SlidingPanelController(mainViewController: mainViewController, leftViewController: leftViewController)

    slidingPanelController.statusBarStyle = .LightContent
    
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    self.window?.rootViewController = slidingPanelController
    self.window?.makeKeyAndVisible()
    
    return true
  }
  
}

