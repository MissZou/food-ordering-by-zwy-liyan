//
//  AccountViewController.swift
//  FoodOrderingSystem
//
//  Created by MoonSlides on 16/2/2.
//  Copyright © 2016年 李龑. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    
    
    @IBOutlet weak var Menu: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        let account = Account.sharedManager
        print(account.accountId!)
    }
    
    func openMenu(){
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func backToMenu(sender: AnyObject) {
        dismissLeftToRight()
        //dismissViewControllerAnimated(true, completion: nil)
        //self.navigationController?.popViewControllerAnimated(true)
    }
    func dismissLeftToRight(){
        let transition = CATransition()
        transition.duration = 0.35
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        
        let containerView = self.view.window
        containerView?.layer.addAnimation(transition, forKey: nil)
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
}
