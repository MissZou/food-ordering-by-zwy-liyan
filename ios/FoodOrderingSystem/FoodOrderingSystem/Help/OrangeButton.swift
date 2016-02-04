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
        self.backgroundColor = UIColor.init(red: 69/255, green: 83/255, blue: 153/255, alpha: 1)
        
    }
    override var highlighted: Bool {
        didSet {
            if highlighted {
                backgroundColor = UIColor.init(red: 83/255, green: 98/255, blue: 178/255, alpha: 1)

            } else {
                backgroundColor = UIColor.init(red: 69/255, green: 83/255, blue: 153/255, alpha: 1)

            }
        }
    }
    
    
}