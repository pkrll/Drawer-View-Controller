//
//  MessagesViewController.swift
//  SlidingPanel
//
//  Created by Ardalan Samimi on 25/03/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController {
  
  @IBAction func togglePanel(sender: AnyObject) {
    NSNotificationCenter.defaultCenter().postNotificationName(DrawerViewOptions.toggleDrawerNotificationKey, object: nil)
  }

  deinit {
    print("MessagesViewController: Goodbye!")
  }

}
