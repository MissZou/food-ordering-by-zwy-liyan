//
//  ViewController.swift
//  FoodOrderingSystem
//
//  Created by MoonSlides on 16/1/16.
//  Copyright © 2016年 李龑. All rights reserved.
//

import UIKit

class TutorialRootViewController: UIViewController, UIPageViewControllerDataSource, AccountDelegate {

    var pageViewController: UIPageViewController?
    var arrayPageTitles: NSArray?
    var arrayPageTexts: NSArray?
    var arrayImages: NSArray?
    let introText1 = "Meals arrive on-demand or you can schedule delivery up to a week in advance for beyond-easy meal-planning."
    let introText2 = "Our friendly delivery folk arrive with your food, still chilled so it stays fresh. We’ll bring it right to your front door. Or your desk. Or your friend's place."
    let introText3 = "Mealtimes are more than food. They’re time to relax. Sometimes that means recharging all by yourself, other times it’s about connecting with friends and family. However you eat dinner, we’re here to make it as easy as it is delicious."
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let token = NSUserDefaults.standardUserDefaults().stringForKey("token") {
            let account = Account.sharedManager
            account.token = token
            account.delegate = self
            account.checkLoginStatus()
        }
        
        arrayPageTitles = ["DINNER MADE EASY", "DELIVERED ANYWHERE", "DINNERS YOU WANT"]
        arrayImages = ["introductionPic1.jpg", "introductionPic2.jpg", "introductionPic3.jpg"]
        arrayPageTexts = [introText1, introText2, introText3]
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? UIPageViewController
        self.pageViewController?.dataSource = self
        let startingViewController = self.viewControllerAtIndex(0)
        let viewControllers: NSArray = [startingViewController!]
        self.pageViewController?.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated: false, completion: nil)
        
        self.pageViewController!.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        self.addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        self.pageViewController?.didMoveToParentViewController(self)
        //performSegueWithIdentifier("login", sender: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func viewControllerAtIndex(index: UInt) -> TutorialPage? {
        if ((self.arrayPageTitles!.count == 0) || (Int(index) >= self.arrayPageTitles!.count)) {
            return nil
        }
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as! TutorialPage
        pageContentViewController.imageFile = self.arrayImages![Int(index)] as! String
        pageContentViewController.textTitle = self.arrayPageTitles![Int(index)] as! String
        pageContentViewController.textContents = self.arrayPageTexts![Int(index)] as! String
        
        pageContentViewController.pageIndex = index
        return pageContentViewController
    }


    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! TutorialPage).pageIndex
        if (index == 0 || Int(index) == NSNotFound) {
            return nil;
        }
        index--
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! TutorialPage).pageIndex
        
        if Int(index) == NSNotFound {
            return nil
        }
        
        index++
        
        if Int(index) == arrayPageTitles!.count {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.arrayPageTitles!.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension TutorialRootViewController {


    func finishLogin(result: NSDictionary, account: Account) {
        if let success = result.objectForKey("success") {
            if success as! NSObject == true {
//                let storyboard = UIStoryboard(name: "SlideMenu", bundle: nil)
//                let mainMenu = storyboard.instantiateViewControllerWithIdentifier("slideMenu")
//                presentViewController(mainMenu, animated: true, completion: nil)
                
            }
        }
    }
}
