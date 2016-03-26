//
//  PanelViewController.swift
//  SlidingPanel
//
//  Created by Ardalan Samimi on 26/03/16.
//  Copyright © 2016 Ardalan Samimi. All rights reserved.
//
import UIKit

struct DrawerViewOptions {
  /**
   *  Notification name for toggle panel.
   */
  internal static var toggleDrawerNotificationKey: String = "togglePanel"
  /**
   *  Animation duration for opening the drawer.
   */
  internal static var presentDrawerAnimationDuration: CGFloat = 0.5
  /**
   *  Animation duration for closing the drawer.
   */
  internal static var dismissDrawerAnimationDuration: CGFloat = 0.5
  /**
   *  The damping ratio for opening the drawer.
   */
  internal static var presentDrawerAnimationDampingRatio: CGFloat = 1.0
  /**
   *  The maximum x origin for the root view.
   */
  internal static var rootViewMaxOriginX: CGFloat = 80.0
  
  internal static var drawerThresholdRatio: CGFloat = 3.0
  
  internal static var dropShadowOffset: CGSize = CGSizeMake(-5, 0)
  internal static var dropShadowOpacity: Float = 0.4
  internal static var dropShadowRadius: CGFloat = 7.0
}

class DrawerViewController: UIViewController {
  
  // MARK: - General Properties
  
  internal var rootViewController: UIViewController!
  
  internal var leftViewController: UIViewController!
  
  internal var statusBarStyle: UIStatusBarStyle = .Default
  
  internal var drawerIsOpen: Bool {
    return self.rootViewController.view.frame.origin.x > 0
  }
  
  internal var shouldContinueTransition: Bool {
    return self.rootViewController.view.frame.origin.x >= self.view.frame.size.width / DrawerViewOptions.drawerThresholdRatio
  }
  
  // MARK: - Gesture Recognizer Properties
  
  internal var screenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer!
  internal var rootViewPanGestureRecognizer: UIPanGestureRecognizer!
  internal var rootViewTapGestureRecognizer: UITapGestureRecognizer!
  
  // MARK: - Initializer Methods
  
  convenience init(rootViewController: UIViewController?, leftViewController: UIViewController? = nil) {
    self.init()
    
    if let viewController = rootViewController {
      self.rootViewController = viewController
      self.addChildViewController(viewController)
    }
    
    if let viewController = leftViewController {
      self.leftViewController = viewController
      // Should it be added as a child view controller from the start?
    }
  }
  
  // MARK: - Set- & Startup Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.registerForNotifications()
    self.initGestureRecognizers()
    self.addGestureRecognizers()
  }
  
  func registerForNotifications() {
    let togglePanel = DrawerViewOptions.toggleDrawerNotificationKey
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "toggleDrawer", name: togglePanel, object: nil)
  }
  
  func initGestureRecognizers() {
    self.rootViewPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
    self.rootViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
    self.screenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "handleEdgePanGesture:")
    self.screenEdgePanGestureRecognizer.edges = .Left
    self.view.addGestureRecognizer(self.screenEdgePanGestureRecognizer)
  }
  
  func addGestureRecognizers() {
    self.rootViewPanGestureRecognizer.enabled = false
    self.rootViewTapGestureRecognizer.enabled = false
    self.rootViewController.view.addGestureRecognizer(self.rootViewPanGestureRecognizer)
    self.rootViewController.view.addGestureRecognizer(self.rootViewTapGestureRecognizer)
  }
  
  func clearGestureRecognizer() {
    self.rootViewController.view.removeGestureRecognizer(self.rootViewPanGestureRecognizer)
    self.rootViewController.view.removeGestureRecognizer(self.rootViewTapGestureRecognizer)
  }
  
  // MARK: - User Interface Methods
  
  func addShadowToView(view: UIView) {
    view.layer.masksToBounds = false
    view.layer.shadowColor = UIColor.blackColor().CGColor
    view.layer.shadowOffset = DrawerViewOptions.dropShadowOffset
    view.layer.shadowRadius = DrawerViewOptions.dropShadowRadius
    view.layer.shadowOpacity = DrawerViewOptions.dropShadowOpacity
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
  
  override func addChildViewController(childController: UIViewController) {
    self.addChildViewController(childController, atIndex: 0)
  }
  
  func addChildViewController(childController: UIViewController, atIndex: Int) {
    super.addChildViewController(childController)
    childController.view.frame = self.view.frame
    self.view.insertSubview(childController.view, atIndex: atIndex)
    childController.didMoveToParentViewController(self)
  }
  
  func popChildViewController(childController: UIViewController) {
    childController.willMoveToParentViewController(nil)
    childController.view.removeFromSuperview()
    childController.removeFromParentViewController()
  }
  
  func isParentToChild(viewController: UIViewController) -> Bool {
    return self.childViewControllers.contains(viewController)
  }
  
  // MARK: - Panel Methods
  
  func toggleDrawer() {
    if self.drawerIsOpen {
      self.dismissDrawer()
    } else {
      self.presentDrawer()
    }
  }
  
  func presentDrawer() {
    let duration = DrawerViewOptions.presentDrawerAnimationDuration
    let dampings = DrawerViewOptions.presentDrawerAnimationDampingRatio
    
    let animations = {
      self.leftViewController.view.frame.origin.x = 0
      self.rootViewController.view.frame.origin.x = self.view.frame.width - DrawerViewOptions.rootViewMaxOriginX
    }
    
    let completion = {(_: Bool) -> Void in
      self.rootViewTapGestureRecognizer.enabled = true
      self.rootViewPanGestureRecognizer.enabled = true
      self.screenEdgePanGestureRecognizer.enabled = false
    }

    self.beginTransition(toViewController: self.leftViewController)
    self.animateTransition(duration, dampingRatio: dampings, animations: animations, completion: completion)
  }
  
  func dismissDrawer() {
    let duration = DrawerViewOptions.dismissDrawerAnimationDuration
    let dampings = DrawerViewOptions.presentDrawerAnimationDampingRatio
    
    let animations = {
      self.rootViewController.view.frame.origin.x = 0
      self.leftViewController.view.frame.origin.x = -self.view.frame.width
    }
    
    let completion = {(_: Bool) -> Void in
      self.rootViewTapGestureRecognizer.enabled = false
      self.rootViewPanGestureRecognizer.enabled = false
      self.screenEdgePanGestureRecognizer.enabled = true
      self.popChildViewController(self.leftViewController)
    }

    self.animateTransition(duration, dampingRatio: dampings, animations: animations, completion: completion)
  }
  
  // MARK: - View Transition Methods
  
  func beginTransition(toViewController viewController: UIViewController, fromLeft: Bool = true) {
    if self.isParentToChild(viewController) == false {
      if fromLeft {
        self.addChildViewController(viewController)
        viewController.view.frame.origin.x = -self.view.frame.width
      } else {
        self.addChildViewController(viewController, atIndex: 1)
        viewController.view.frame.origin.x = self.view.frame.width
      }
    }
  }
  
  func transition(toViewController viewController: UIViewController, animated: Bool = false, withDuration: CGFloat = 0.0, completion: () -> Void?) {
    self.beginTransition(toViewController: viewController, fromLeft: false)
    
    if animated {
      let animations = {
        self.popChildViewController(self.rootViewController)
        viewController.view.frame.origin.x = 0
      }
      
      let completion = {(_: Bool) -> Void in
        self.rootViewController = viewController
        self.screenEdgePanGestureRecognizer.enabled = true
        self.addGestureRecognizers()
        completion()
      }
      
      self.animateTransition(withDuration, dampingRatio: 1.0, animations: animations, completion: completion)
    }
  }

  func animateTransition(withDuration: CGFloat, dampingRatio: CGFloat, animations: () -> Void, completion: ((Bool) -> Void)?) {
    UIView.animateWithDuration(NSTimeInterval(withDuration), delay: 0.0, usingSpringWithDamping: dampingRatio, initialSpringVelocity: withDuration, options: [], animations: animations, completion: completion)
  }
  
  // MARK: _ Gesture Recognizer Methods
  
  func handleEdgePanGesture(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
    switch gestureRecognizer.state {
    case .Began:
      self.beginTransition(toViewController: self.leftViewController)
      self.leftViewController.view.frame.origin.x = 0
      fallthrough
    case .Changed:
      let location = gestureRecognizer.locationInView(self.view)
      self.rootViewController.view.frame.origin.x = location.x
    default:
      if self.shouldContinueTransition {
        self.presentDrawer()
      } else {
        self.dismissDrawer()
      }
    }
  }
  
  func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer) {
    if self.drawerIsOpen == false {
      return
    }
    
    switch gestureRecognizer.state {
    case .Began:
      fallthrough
    case .Changed:
      let translation = gestureRecognizer.translationInView(self.view)
      let centerPoint = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y)
      // This prevents the view from jumping back when the user begins dragging the view to close the panel.
      if centerPoint.x > self.view.center.x {
        gestureRecognizer.view!.center = centerPoint
        gestureRecognizer.setTranslation(CGPointZero, inView: self.rootViewController.view)
      } else {
        self.dismissDrawer()
      }
    default:
        self.dismissDrawer()
    }
  }

  func handleTapGesture(gestureRecognizer: UITapGestureRecognizer) {
    if self.drawerIsOpen {
      self.dismissDrawer()
    }
  }
  
}
