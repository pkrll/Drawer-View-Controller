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
    NSNotificationCenter.defaultCenter().postNotificationName(SlidingPanelOptions.togglePanelNotificationKey, object: self)
  }

}

