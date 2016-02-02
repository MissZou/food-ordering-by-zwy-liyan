//
//  LeftSlideMenu.swift
//  SlideMenu
//
//  Created by MoonSlides on 16/2/1.
//  Copyright © 2016年 李龑. All rights reserved.
//

import UIKit

class LeftSlideMenu: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("swipeLeftAction:"))
//        swipeLeft.direction = .Left
//        view.addGestureRecognizer(swipeLeft)
        self.prefersStatusBarHidden()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.prefersStatusBarHidden()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
//    func swipeLeftAction(rec: UISwipeGestureRecognizer){
//        NSNotificationCenter.defaultCenter().postNotificationName("closeMenuViaNotification", object: nil)
//    }
}
