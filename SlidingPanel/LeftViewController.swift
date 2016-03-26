//
//  LeftViewController.swift
//  SlidingPanel
//
//  Created by Ardalan Samimi on 24/03/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet var tableView: UITableView!
  
  private let menuItems = [
    "Home",
    "Messages",
    "Settings",
    "Logout"
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.delegate = self
    self.tableView.dataSource = self
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.menuItems.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("menuCell")!
    
    if let label = cell.viewWithTag(100) as? UILabel {
      let text = self.menuItems[indexPath.row]
      
      if text.isEmpty == false {
        label.text = text
      } else {
        label.text = nil
      }
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let parentViewController = self.parentViewController as? DrawerViewController {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let controller: UIViewController
      
      if indexPath.row == 0 {
        controller = storyboard.instantiateInitialViewController()!
      } else {
        controller = storyboard.instantiateViewControllerWithIdentifier("MessagesNavigation")
      }

      parentViewController.transition(toViewController: controller, animated: true, withDuration: 0.5, completion: { () -> Void? in
        print("Done!")
      })
    }
  }
  
}
