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
    @IBOutlet weak var nameIndicator: UIImageView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        let account = Account.sharedManager
        account.delegate = nil
        account.checkLoginStatus()
        avatar.backgroundColor = UIColor(red: 63/255, green: 72/255, blue: 104/255, alpha: 0.5)
        if let imageUrl = account.photoUrl {
            avatar.image = UIImage(data: NSData(contentsOfURL: NSURL(string: imageUrl)!)!)
        }
        //        avatar.image = UIImage(data: NSData(contentsOfURL: NSURL(string: account.photoUrl!)!)!)
        email.text = account.email
        name.text = account.name
        nameIndicator.image = UIImage(named: "nameIndicator.png")
        //navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func backToMenu(sender: AnyObject) {
        dismissLeftToRight()
    }
    func dismissLeftToRight(){
        let transition = CATransition()
        transition.duration = 0.35
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        
        let containerView = self.view.window
        containerView?.layer.addAnimation(transition, forKey: nil)
        dismissViewControllerAnimated(false, completion: nil)
    }
    
}
