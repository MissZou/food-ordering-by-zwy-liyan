//
//  ViewController.swift
//  SlideMenu
//
//  Created by MoonSlides on 16/1/31.
//  Copyright © 2016年 李龑. All rights reserved.
//

import UIKit

class SlideMenu: UIViewController {

    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var leftMenuWidth:CGFloat = 100
    var mainMenuViewController: MainMenuViewController!

    var swipeLeftGesture:UISwipeGestureRecognizer?
    var tapToCloseMenuGesture: UITapGestureRecognizer?
    var blurEffect: UIBlurEffect?
    var blurEffectView: UIVisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        dispatch_async(dispatch_get_main_queue()) {
//            self.closeMenu(false)
//        }
        
        swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: Selector("closeMenuViaNotification"))
        swipeLeftGesture!.direction = .Left
        
        tapToCloseMenuGesture = UITapGestureRecognizer(target: self, action: "closeMenuViaNotification")

        blurEffect = UIBlurEffect(style: .Dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = CGRectMake(rightView.frame.origin.x - leftMenuWidth, rightView.frame.origin.y, rightView.frame.size.width, rightView.frame.size.height)
        blurEffectView?.addGestureRecognizer(tapToCloseMenuGesture!)
        rightView.addSubview(blurEffectView!)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "toggleMenu", name: "toggleMenu", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeMenuViaNotification", name: "closeMenuViaNotification", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openMenu", name: "openMenu", object: nil)

        scrollView.scrollEnabled = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        view.addGestureRecognizer(swipeLeftGesture!)
    }

    func initSlideMenu(){
        let screenWith = UIScreen.mainScreen().bounds.size.width
        leftView.frame.size.width = screenWith*0.8

        leftMenuWidth = leftView.frame.size.width
        leftView.frame.origin.x = 0
        
        rightView.frame.size.width = screenWith - leftMenuWidth
        rightView.frame.origin.x = leftView.frame.origin.x + leftView.frame.size.width
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "toggleMenu", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "closeMenuViaNotification", object: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func toggleMenu(){
        scrollView.contentOffset.x == 0  ? closeMenu() : openMenu()
    }
    
    func closeMenuViaNotification(){
        closeMenu()
    }

    func closeMenu(animated:Bool = true){
        scrollView.setContentOffset(CGPoint(x: leftMenuWidth, y: 0), animated: animated)
        blurEffectView?.removeFromSuperview()
        view.removeGestureRecognizer(swipeLeftGesture!)
        blurEffectView?.removeGestureRecognizer(tapToCloseMenuGesture!)
    }
    
    func openMenu(){
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        rightView.addSubview(blurEffectView!)
        blurEffectView!.addGestureRecognizer(tapToCloseMenuGesture!)
        view.addGestureRecognizer(swipeLeftGesture!)
    }

    func openMainMenuView(){
        performSegueWithIdentifier("mainMenu", sender: nil)
    }
}

