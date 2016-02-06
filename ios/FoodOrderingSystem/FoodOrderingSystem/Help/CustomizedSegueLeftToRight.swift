//
//  CustomizedSegueLeftToRight.swift
//  FoodOrderingSystem
//
//  Created by MoonSlides on 16/2/4.
//  Copyright © 2016年 李龑. All rights reserved.
//

import UIKit

class CustomizedSegueLeftToRight: UIStoryboardSegue {

    override func perform() {
        
        let sourceViewController = self.sourceViewController.view as UIView
        let destinationViewController = self.destinationViewController.view as UIView
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        destinationViewController.frame = CGRectMake(sourceViewController.frame.origin.x + screenWidth, sourceViewController.frame.origin.y, screenWidth, screenHeight)
        
        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(destinationViewController, aboveSubview: sourceViewController)
        
        var destinationFrame = destinationViewController.frame
        destinationFrame = CGRectMake(sourceViewController.frame.origin.x, sourceViewController.frame.origin.y, destinationFrame.size.width, destinationFrame.size.height)
        
        UIView.animateWithDuration(0.35, animations: {
            () -> Void in
            //sourceViewController.frame = CGRectOffset(sourceViewController.frame, -sourceViewController.frame.size.width, 0)
                destinationViewController.frame = destinationFrame
            
            }) {(Finished) -> Void in
                self.sourceViewController.presentViewController(self.destinationViewController as UIViewController,
                    animated: false,
                    completion: nil)
                
        }

    }

}
