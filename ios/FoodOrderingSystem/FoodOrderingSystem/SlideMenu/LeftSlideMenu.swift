//
//  LeftSlideMenu.swift
//  SlideMenu
//
//  Created by MoonSlides on 16/2/1.
//  Copyright © 2016年 李龑. All rights reserved.
//

import UIKit

class LeftSlideMenu: UIViewController {
    
    @IBOutlet weak var greenButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("swipeLeftAction:"))
//        swipeLeft.direction = .Left
//        view.addGestureRecognizer(swipeLeft)
        self.prefersStatusBarHidden()
        self.setNeedsStatusBarAppearanceUpdate()
        greenButton.layer.shadowOpacity = 0.2
        //greenButton.layer.shadowOffset = CGSize(width: -2, height: -25)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.prefersStatusBarHidden()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func greenButtonClicked(sender: AnyObject) {
                    NSNotificationCenter.defaultCenter().postNotificationName("openAccountView", object: nil)
    }
    
//    func swipeLeftAction(rec: UISwipeGestureRecognizer){
//        NSNotificationCenter.defaultCenter().postNotificationName("closeMenuViaNotification", object: nil)
//    }
}
