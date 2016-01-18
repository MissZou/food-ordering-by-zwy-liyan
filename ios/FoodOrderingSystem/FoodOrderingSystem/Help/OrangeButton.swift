//
//  OrangeButton.swift
//  FoodOrderingSystem
//
//  Created by MoonSlides on 16/1/16.
//  Copyright © 2016年 李龑. All rights reserved.
//

import Foundation
import UIKit

class OrangeButton: UIButton {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 4.0;
        self.clipsToBounds = true
        self.backgroundColor = UIColor.init(red: 242/255, green: 114/255, blue: 66/255, alpha: 1)
        
    }
    override var highlighted: Bool {
        didSet {
            if highlighted {
                backgroundColor = UIColor.init(red: 255/255, green: 90/255, blue: 31/255, alpha: 1)

            } else {
                backgroundColor = UIColor.init(red: 242/255, green: 114/255, blue: 66/255, alpha: 1)

            }
        }
    }
    
    
}