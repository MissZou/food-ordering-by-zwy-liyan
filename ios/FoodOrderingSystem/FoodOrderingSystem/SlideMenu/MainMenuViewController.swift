//
//  MainMenuViewController.swift
//  SlideMenu
//
//  Created by MoonSlides on 16/1/31.
//  Copyright © 2016年 李龑. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    var isMenuAppered:Bool = false
    
    @IBOutlet weak var slideMenuButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openAccountView", name: "openAccountView", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openOrderView", name: "openOrderView", object: nil)

        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("dismissMenu"))
        //let swiptGesture = UISwipeGestureRecognizer(target: self, action: Selector("openMenu"))
        
        view.addGestureRecognizer(tapGesture)
        //view.addGestureRecognizer(swiptGesture)
        
        slideMenuButton.setImage(self.defaultMenuImage(), forState: .Normal)
        
    }
    @IBAction func menu(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
        
    }
    
    func openMenu(){
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    }
    
    func dismissMenu(){
            NSNotificationCenter.defaultCenter().postNotificationName("closeMenuViaNotification", object: nil)
    }
    
    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        struct Static {
            static var onceToken: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.onceToken, { () -> Void in
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 22), false, 0.0)
            
            UIColor.blackColor().setFill()
            UIBezierPath(rect: CGRectMake(0, 3, 30, 1)).fill()
            UIBezierPath(rect: CGRectMake(0, 10, 30, 1)).fill()
            UIBezierPath(rect: CGRectMake(0, 17, 30, 1)).fill()
            
            UIColor.whiteColor().setFill()
            UIBezierPath(rect: CGRectMake(0, 4, 30, 1)).fill()
            UIBezierPath(rect: CGRectMake(0, 11,  30, 1)).fill()
            UIBezierPath(rect: CGRectMake(0, 18, 30, 1)).fill()
            
            defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
        })
        
        return defaultMenuImage;
    }
  
    
    
    func openAccountView(){
        self.performSegueWithIdentifier("account", sender: nil)
    }
    
    func openOrderView(){
        self.performSegueWithIdentifier("order", sender: nil)
    }
}
