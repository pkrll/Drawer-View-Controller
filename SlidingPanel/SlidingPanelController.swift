//
//  SlidingPanelController.swift
//  SlidingPanel
//
//  Created by Ardalan Samimi on 24/03/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import UIKit

struct SlidingPanelOptions {
  
  internal static var togglePanelNotificationKey: String = "togglePanel"
  internal static var slideOpenAnimationDuration: CGFloat = 1.0
  internal static var closeDownAnimationDuration: CGFloat = 0.5
  internal static var draggingThresholdRatio: CGFloat = 3.0
  internal static var mainViewMaxOriginX: CGFloat = 80.0
  internal static var mainViewMinOriginX: CGFloat = -80.0
  internal static var dropShadowOffset: CGSize = CGSizeMake(-5, 0)
  internal static var dropShadowOpacity: Float = 0.4
  internal static var dropShadowRadius: CGFloat = 7.0
  
}

class SlidingPanelController: UIViewController {
  
  // MARK: - General Properties
  /**
  *  The current view controller in focus.
  *  - Note: The value of this property changes as a new view controller is presented or dismissed.
  */
  internal var currentViewController: UIViewController!
  /**
   *  The main (center) view controller.
   */
  internal var mainViewController: UIViewController!
  /**
   *  The left most view controller.
   */
  internal var leftViewController: UIViewController!
  /**
   *  The style of the device’s status bar.
   *  - Note: Change this to override the default the status bar style, when using the Sliding Panel Controller as container view controller.
   */
  internal var statusBarStyle: UIStatusBarStyle = .Default
  
  internal var panelIsOpen: Bool {
    return (self.mainViewController.view.frame.origin.x > 0)
  }
  
  // MARK: - Gesture Recognizers Properties
  
  internal var edgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer!
  internal var panGestureRecognizer: UIPanGestureRecognizer!
  internal var tapGestureRecognizer: UITapGestureRecognizer!
  
  // MARK: - Initializers
  convenience init(mainViewController: UIViewController) {
    self.init(mainViewController: mainViewController, leftViewController: nil)
  }
  
  convenience init(mainViewController: UIViewController, leftViewController: UIViewController?) {
    self.init()
    self.mainViewController = mainViewController
    self.leftViewController = leftViewController
    self.currentViewController = self.mainViewController
    self.addChildViewController(self.mainViewController)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.addGestureRecognizers()
    self.registerForNotifications()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return self.statusBarStyle
  }
  
  func registerForNotifications() {
    let togglePanel = SlidingPanelOptions.togglePanelNotificationKey
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "togglePanel", name: togglePanel, object: nil)
  }
  
  func addGestureRecognizers() {
    self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
    self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
    self.panGestureRecognizer.enabled = false
    self.tapGestureRecognizer.enabled = false
    self.edgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "handleEdgePanGesture:")
    self.edgePanGestureRecognizer.edges = .Left
    self.view.addGestureRecognizer(self.edgePanGestureRecognizer)
    self.mainViewController.view.addGestureRecognizer(self.panGestureRecognizer)
    self.mainViewController.view.addGestureRecognizer(self.tapGestureRecognizer)
    
  }
  
  // MARK: - User Interface Methods
  
  func addShadowToView(view: UIView) {
    view.layer.masksToBounds = false
    view.layer.shadowColor = UIColor.blackColor().CGColor
    view.layer.shadowOffset = SlidingPanelOptions.dropShadowOffset
    view.layer.shadowRadius = SlidingPanelOptions.dropShadowRadius
    view.layer.shadowOpacity = SlidingPanelOptions.dropShadowOpacity
    view.layer.shadowPath = UIBezierPath(rect: view.bounds).CGPath
  }
  
  func removeShadowFromView(view: UIView) {
    view.layer.masksToBounds = true
    view.layer.shadowOffset = CGSizeZero
    view.layer.shadowRadius = 0
    view.layer.shadowOpacity = 0
    view.layer.shadowPath = nil
  }
  
  // MARK: - Child View Controller Methods
  /**
  *  Properly adds a child view controller to the container view controller.
  *  - Parameters:
  *    - childController: The view controller to be added as a child.
  */
  override func addChildViewController(childController: UIViewController) {
    super.addChildViewController(childController)
    childController.view.frame = self.view.frame
    self.view.insertSubview(childController.view, atIndex: 0)
    childController.didMoveToParentViewController(self)
  }
  /**
   *  Properly removes a child view controller from the container view controller.
   *  - Parameters:
   *    - childController: The view controller to be removed as a child.
   */
  func hideChildViewController(childController: UIViewController) {
    childController.willMoveToParentViewController(nil)
    childController.view.removeFromSuperview()
    childController.removeFromParentViewController()
  }
  
  func doesContainChildViewController(childController: UIViewController) -> Bool {
    return self.childViewControllers.contains(childController)
  }
  
  func viewHasPassedThreshold(view: UIView) -> Bool {
    return view.frame.origin.x >= self.view.frame.size.width / SlidingPanelOptions.draggingThresholdRatio
  }
  
  // MARK: - Transition Methods
  
  func togglePanel() {
    if self.panelIsOpen {
      self.dismissViewController(self.leftViewController)
    } else {
      self.presentViewController(self.leftViewController)
    }
  }
  
  func presentViewController(viewController: UIViewController) {
    self.beginViewTransition(viewController)
    
    let openDuration: CGFloat = SlidingPanelOptions.slideOpenAnimationDuration
    let dampingRatio: CGFloat = 0.9
    let animations = {
      self.mainViewController.view.frame.origin.x = self.view.frame.width - SlidingPanelOptions.mainViewMaxOriginX
    }
    let completion = {(_: Bool) -> Void in
      self.tapGestureRecognizer.enabled = true
      self.panGestureRecognizer.enabled = true
      self.edgePanGestureRecognizer.enabled = false
    }
    
    self.animateViewTransition(openDuration, dampingRatio: dampingRatio, animations: animations, completion: completion)
  }
  
  func dismissViewController(viewController: UIViewController) {
    let shutDuration: CGFloat = SlidingPanelOptions.closeDownAnimationDuration
    let dampingRatio: CGFloat = 1.0
    let animations = {
      self.mainViewController.view.frame.origin.x = 0
    }
    let completion = {(_: Bool) -> Void in
      self.tapGestureRecognizer.enabled = false
      self.panGestureRecognizer.enabled = false
      self.edgePanGestureRecognizer.enabled = true
      self.hideChildViewController(viewController)
      self.removeShadowFromView(self.mainViewController.view)
    }
    
    self.animateViewTransition(shutDuration, dampingRatio: dampingRatio, animations: animations, completion: completion)
  }
  
  func beginViewTransition(viewController: UIViewController) {
    if self.doesContainChildViewController(viewController) == false {
      self.addChildViewController(viewController)
      self.addShadowToView(self.mainViewController.view)
    }
  }
  
  func animateViewTransition(withDuration: CGFloat, dampingRatio: CGFloat, animations: () -> Void, completion: ((Bool) -> Void)?) {
    UIView.animateWithDuration(NSTimeInterval(withDuration), delay: 0.0, usingSpringWithDamping: dampingRatio, initialSpringVelocity: withDuration, options: [], animations: animations, completion: completion)
  }
  
  // MARK: Gesture Recognizer Methods
  
  func gestureWasCancelled() {
    if self.viewHasPassedThreshold(self.mainViewController.view) {
      self.presentViewController(self.leftViewController)
    } else {
      self.dismissViewController(self.leftViewController)
    }
  }
  
  func handleEdgePanGesture(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
    switch (gestureRecognizer.state) {
    case .Began:
      self.beginViewTransition(self.leftViewController)
      fallthrough
    case .Changed:
      let location = gestureRecognizer.locationInView(self.view)
      self.mainViewController.view.frame.origin.x = location.x
    default:
      self.gestureWasCancelled()
    }
  }
  
  func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer) {
    if panelIsOpen {
      switch (gestureRecognizer.state) {
      case .Began:
        fallthrough
      case .Changed:
        let translation = gestureRecognizer.translationInView(self.view)
        let centerPoint = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y)
        
        if centerPoint.x > self.view.center.x {
          gestureRecognizer.view!.center = centerPoint
          gestureRecognizer.setTranslation(CGPointZero, inView: self.mainViewController.view)
        } else {
          self.dismissViewController(self.leftViewController)
        }
      default:
        self.dismissViewController(self.leftViewController)
      }
    }
  }
  
  func handleTapGesture(gestureRecognizer: UITapGestureRecognizer) {
    if self.panelIsOpen {
      self.dismissViewController(self.leftViewController)
    }
  }
  
}