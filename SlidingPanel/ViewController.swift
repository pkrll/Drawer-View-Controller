//
//  ViewController.swift
//  SlidingPanel
//
//  Created by Ardalan Samimi on 24/03/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBAction func toggleMenu(sender: AnyObject) {
    NSNotificationCenter.defaultCenter().postNotificationName(DrawerViewOptions.toggleDrawerNotificationKey, object: self)
  }

  deinit {
    print("[12:20] ViewController says: Goodbye, cruel world!")
  }
  
  override func didMoveToParentViewController(parent: UIViewController?) {
    print(parent)
    super.didMoveToParentViewController(parent)
  }
  
}

