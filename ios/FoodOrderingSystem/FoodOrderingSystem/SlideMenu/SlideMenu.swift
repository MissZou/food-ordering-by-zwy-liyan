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
    // @IBOutlet weak var scrollView: ScrollViewWithTableView!
    
    
    var leftMenuWidth:CGFloat = 100
    var mainMenuViewController: MainMenuViewController!
    
    var swipeLeftGesture:UISwipeGestureRecognizer?
    var tapToCloseMenuGesture: UITapGestureRecognizer?
    var blurEffect: UIBlurEffect?
    var blurEffectView: UIVisualEffectView?
    
    var startLocation:CGPoint?
    var currentLoaction:CGPoint?
    var swipeOffset:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rightView.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
        
        swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: Selector("closeMenuViaNotification"))
        swipeLeftGesture!.direction = .Left
        tapToCloseMenuGesture = UITapGestureRecognizer(target: self, action: "closeMenuViaNotification")
        let panGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "panedGestureDo:")
        panGesture.delegate = self
        panGesture.edges = UIRectEdge.Left
        view.addGestureRecognizer(panGesture)
        
        blurEffect = UIBlurEffect(style: .Dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = CGRectMake(rightView.frame.origin.x, rightView.frame.origin.y, rightView.frame.size.width, rightView.frame.size.height)
        blurEffectView?.addGestureRecognizer(tapToCloseMenuGesture!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "toggleMenu", name: "toggleMenu", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeMenuViaNotification", name: "closeMenuViaNotification", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openMenu", name: "openMenu", object: nil)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        view.addGestureRecognizer(swipeLeftGesture!)
        leftView.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 0, view.frame.size.height)
        blurEffectView?.removeFromSuperview()
        
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
        //  scrollView.contentOffset.x == 0  ? closeMenu() : openMenu()
        //print("toggle menu")
        //print(leftView.frame.width)
        rightView.frame.origin.x == 0 ?  openMenu() : closeMenu()
    }
    
    func closeMenuViaNotification(){
        closeMenu(true)
    }
    
    func closeMenuHalfAnimation(){
        UIView.beginAnimations(nil , context: nil)
        UIView.setAnimationDuration(0.2)
        
        leftView.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, leftMenuWidth, view.frame.size.height)
        rightView.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
        
        blurEffectView?.alpha = 0
        //blurEffectView?.removeFromSuperview()
        UIView.commitAnimations()
        
        //blurEffectView?.removeFromSuperview()
        view.removeGestureRecognizer(swipeLeftGesture!)
        blurEffectView?.removeGestureRecognizer(tapToCloseMenuGesture!)
    }
    
    func openMenuHalfAnimation() {
        UIView.beginAnimations(nil , context: nil)
        UIView.setAnimationDuration(0.2)
        
        leftView.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, leftMenuWidth, view.frame.size.height)
        rightView.frame = CGRectMake(view.frame.origin.x + leftMenuWidth, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
        
        
        rightView.addSubview(blurEffectView!)
        blurEffectView?.alpha = 1
        UIView.commitAnimations()
        blurEffectView!.addGestureRecognizer(tapToCloseMenuGesture!)
        
        view.addGestureRecognizer(swipeLeftGesture!)
    }
    
    
    func closeMenu(animated:Bool = true){
        UIView.beginAnimations(nil , context: nil)
        UIView.setAnimationDuration(0.3)
       blurEffectView?.alpha = 1
        leftView.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, leftMenuWidth, view.frame.size.height)
        rightView.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
        
        blurEffectView?.alpha = 0
        //blurEffectView?.removeFromSuperview()
        UIView.commitAnimations()
        
        //blurEffectView?.removeFromSuperview()
        view.removeGestureRecognizer(swipeLeftGesture!)
        blurEffectView?.removeGestureRecognizer(tapToCloseMenuGesture!)
    }
    
    func openMenu(){
        UIView.beginAnimations(nil , context: nil)
        UIView.setAnimationDuration(0.3)
        
        leftView.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, leftMenuWidth, view.frame.size.height)
        rightView.frame = CGRectMake(view.frame.origin.x + leftMenuWidth, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
        
        blurEffectView?.alpha = 0
        rightView.addSubview(blurEffectView!)
        blurEffectView?.alpha = 1
        UIView.commitAnimations()
        blurEffectView!.addGestureRecognizer(tapToCloseMenuGesture!)

        view.addGestureRecognizer(swipeLeftGesture!)
    }
    
    func panedGestureDo(sender: UIScreenEdgePanGestureRecognizer) {
        sender.enabled = true
        if (sender.state == UIGestureRecognizerState.Began) {
            startLocation = sender.locationInView(self.view);

        }

        currentLoaction = sender.locationInView(self.view)
        let distance = startLocation!.x - currentLoaction!.x
        
        print(distance)
        print(sender.enabled)
        
        if distance < 0 {
            //sender.enabled = true
            rightView.addSubview(blurEffectView!)
            blurEffectView!.addGestureRecognizer(tapToCloseMenuGesture!)
            blurEffectView?.alpha = (-distance)/100
            leftView.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, leftMenuWidth, view.frame.size.height)
            rightView.frame = CGRectMake(view.frame.origin.x - distance, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
            if (rightView.frame.origin.x > 97) {
                rightView.frame = CGRectMake(view.frame.origin.x + leftMenuWidth, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
                openMenuHalfAnimation()
                
            }
            if (rightView.frame.origin.x < 3) {
                rightView.frame = CGRectMake(view.frame.origin.x , view.frame.origin.y, view.frame.size.width, view.frame.size.height)
                closeMenuHalfAnimation()
            }
            
            if (sender.state == UIGestureRecognizerState.Ended) {
                if (rightView.frame.origin.x > 50) {
                    openMenuHalfAnimation()
                    
                }
                if (rightView.frame.origin.x < 50) {
                    closeMenuHalfAnimation()
                }

            }
        } else {
            //sender.enabled = false
        }
        
        
    }
    
}

extension SlideMenu: UIGestureRecognizerDelegate{
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
//        let location = touch.locationInView(view)
//        if location =
//        
//    }
}

//extension SlideMenu : UIScrollViewDelegate {
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        print("scrollView.contentOffset.x:: \(scrollView.contentOffset.x)")
//        blurEffectView?.alpha = (100 - scrollView.contentOffset.x)/100
//        if scrollView.contentOffset.x == 100 {
//            closeMenu()
//            blurEffectView?.removeFromSuperview()
//        }
//
//        if scrollView.contentOffset.x == 0 {
//            openMenu()
//        }
//
//        if  scrollView.contentOffset.x < 95 {
//            rightView.addSubview(blurEffectView!)
//        }
//
//    }
//
//    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if scrollView.contentOffset.x > 20 {
//            closeMenu()
//        }
//        else{
//            openMenu()
//        }
//
//    }
//}
