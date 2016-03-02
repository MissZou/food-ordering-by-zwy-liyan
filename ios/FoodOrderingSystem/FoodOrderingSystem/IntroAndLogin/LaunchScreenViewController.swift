//
//  LaunchScreenViewController.swift
//  FoodOrderingSystem
//
//  Created by MoonSlides on 16/2/18.
//  Copyright © 2016年 李龑. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController, AccountDelegate {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = 5
        avatar.layer.borderColor = UIColor(red: 83/255, green: 98/255, blue: 178/255, alpha: 1).CGColor
        avatar.layer.borderWidth = 2
        
        label.hidden = true
        avatar.hidden = true
        let account = Account.sharedManager
        let myKeyChain = account.myKeychain
        let token = try? myKeyChain.getString("fosToken")
        if ((token)! != nil) {
            account.token = token!
            account.delegate = self
            account.checkLoginStatus()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let account = Account.sharedManager
        let myKeyChain = account.myKeychain
        let token = try? myKeyChain.getString("fosToken")
         if ((token)! != nil) {
        }
        else{
            performSegueWithIdentifier("tutorial", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func finishedAnimation(){
        let storyboard = UIStoryboard(name: "SlideMenu", bundle: nil)
        let mainMenu = storyboard.instantiateViewControllerWithIdentifier("slideMenu")
        presentViewController(mainMenu, animated: true, completion: nil)

    }

}

extension LaunchScreenViewController {
    func finishLogin(result: NSDictionary, account: Account) {
        if let success = result.objectForKey("success") {
            if success as! NSObject == true {
                label.text = "Welcome back, \(account.name)"
                if let imageUrl = account.photoUrl {
                    avatar.image = UIImage(data: NSData(contentsOfURL: NSURL(string: imageUrl)!)!)
                }
                
                self.avatar.hidden = false
                UIView.animateWithDuration(1.0, animations: {
                    self.avatar.frame = CGRectMake(self.avatar.frame.origin.x, self.avatar.frame.origin.y - 25, self.avatar.frame.size.width, self.avatar.frame.size.height)
                    }, completion: { finish in
                        self.label.hidden = false
                        UIView.animateWithDuration(2.0, animations: {
                            self.label.frame = CGRectMake(self.label.frame.origin.x, self.label.frame.origin.y - 40, self.label.frame.size.width, self.label.frame.size.height)
                            }, completion: { finished in
                                let storyboard = UIStoryboard(name: "SlideMenu", bundle: nil)
                                let mainMenu = storyboard.instantiateViewControllerWithIdentifier("slideMenu")
                                self.presentViewController(mainMenu, animated: true, completion: nil)
                        })
                })
                

                
            }
            else {
                performSegueWithIdentifier("tutorial", sender: nil)
            }
        }
    }
}