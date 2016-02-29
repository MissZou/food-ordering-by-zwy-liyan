//
//  ScrollViewWithTableView.swift
//  FoodOrderingSystem
//
//  Created by MoonSlides on 16/2/20.
//  Copyright © 2016年 李龑. All rights reserved.
//

import UIKit

class ScrollViewWithTableView: UIScrollView, UIGestureRecognizerDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        self.nextResponder()?.touchesBegan(touches, withEvent: event)
//    }
//    
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        if(!self.dragging) {
//            self.nextResponder()?.touchesMoved(touches, withEvent: event)
//        }
//
//    }
//    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        self.nextResponder()?.touchesEnded(touches, withEvent: event)
//    }

//    func gestureRecognizer(_: UIGestureRecognizer,
//        shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
//            return true
//    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if ((otherGestureRecognizer.view?.isKindOfClass(UITableView)) != nil){
            return true
        }
        return false
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
