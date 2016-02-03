//
//  AccountViewController.swift
//  FoodOrderingSystem
//
//  Created by MoonSlides on 16/2/2.
//  Copyright © 2016年 李龑. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    
    func openMenu(){
        
    }
    @IBOutlet weak var Menu: UIButton!
    @IBAction func backToMenu(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        //self.navigationController?.popViewControllerAnimated(true)
    }
    
}
