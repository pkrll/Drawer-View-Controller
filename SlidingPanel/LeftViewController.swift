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
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.menuItems.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("menuCell")!
    
    if let label = cell.viewWithTag(100) as? UILabel {
      label.text = self.menuItems[indexPath.row]
    }
    
    return cell
  }
  
}
