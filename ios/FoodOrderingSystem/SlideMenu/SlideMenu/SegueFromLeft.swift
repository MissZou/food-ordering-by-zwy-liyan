//
//  SegueFromLeft.swift
//  SlideMenu
//
//  Created by MoonSlides on 16/2/1.
//  Copyright © 2016年 李龑. All rights reserved.
//

import UIKit

class SegueFromLeft: UIStoryboardSegue {
    
    override func perform() {
        var src: UIViewController = self.sourceViewController as! UIViewController
        var dst: UIViewController = self.destinationViewController as! UIViewController
        var transition: CATransition = CATransition()
        var timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.25
        transition.timingFunction = timeFunc
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        src.navigationController!.view.layer.addAnimation(transition, forKey: kCATransition)
        src.navigationController!.pushViewController(dst, animated: false)
    }
}
