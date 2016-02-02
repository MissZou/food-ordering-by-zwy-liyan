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
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    let leftMenuWidth:CGFloat = 330
    var mainMenuViewController: MainMenuViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //mainMenuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("mainMenu") as! MainMenuViewController
        //rightView.addSubview(mainMenuViewController.view)
        rightView.layer.shadowOpacity = 0.8
        
        dispatch_async(dispatch_get_main_queue()) {
            self.closeMenu(false)
        }
        
        // Tab bar controller's child pages have a top-left button toggles the menu
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "toggleMenu", name: "toggleMenu", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeMenuViaNotification", name: "closeMenuViaNotification", object: nil)

        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "openMenu", name: "openMenu", object: nil)

        
        scrollView.scrollEnabled = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "toggleMenu", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "closeMenuViaNotification", object: nil)
    }
    
    func toggleMenu(){
        print(scrollView
            .contentOffset.x)
        scrollView.contentOffset.x == 0  ? closeMenu() : openMenu()
    }
    
    func closeMenuViaNotification(){
        closeMenu()
    }
    
    // Use scrollview content offset-x to slide the menu.
    func closeMenu(animated:Bool = true){
        scrollView.setContentOffset(CGPoint(x: leftMenuWidth, y: 0), animated: animated)
        //self.mainMenuViewController.isMenuAppered = false
    }
    
    func openMenu(){
        print("opening menu")
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        //self.mainMenuViewController.isMenuAppered = true
    }

}

