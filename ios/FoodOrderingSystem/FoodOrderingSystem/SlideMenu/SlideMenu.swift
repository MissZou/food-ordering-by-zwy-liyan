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
//    var isMenuOpened:Bool = true
    var swipeLeft:UISwipeGestureRecognizer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initSlideMenu()
        dispatch_async(dispatch_get_main_queue()) {
            self.closeMenu(false)
        }
        
        //rightView.layer.shadowOpacity = 0.8

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "toggleMenu", name: "toggleMenu", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeMenuViaNotification", name: "closeMenuViaNotification", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openMenu", name: "openMenu", object: nil)

        scrollView.scrollEnabled = false

        swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("closeMenuViaNotification"))
        swipeLeft!.direction = .Left

        //self.prefersStatusBarHidden()
        self.closeMenu(false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //closeMenu()
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
    
//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }
    
    func toggleMenu(){
        scrollView.contentOffset.x == 0  ? closeMenu() : openMenu()
    }
    
    func closeMenuViaNotification(){
        closeMenu()
    }

    func closeMenu(animated:Bool = true){
        scrollView.setContentOffset(CGPoint(x: leftMenuWidth, y: 0), animated: animated)
        view.removeGestureRecognizer(swipeLeft!)
    }
    
    func openMenu(){
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        view.addGestureRecognizer(swipeLeft!)
        
    }

    func openMainMenuView(){
        performSegueWithIdentifier("mainMenu", sender: nil)
    }
}

