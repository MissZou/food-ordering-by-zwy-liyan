//
//  MainMenuViewController.swift
//  SlideMenu
//
//  Created by MoonSlides on 16/1/31.
//  Copyright © 2016年 李龑. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController, DropDownButtonDelegate {

    var isMenuAppered:Bool = false
    var dropDownAddressButton: DropDownButton?
    
    @IBOutlet var dropDownAddressSender: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var slideMenuButton: UIButton!
    
    var blurEffect:UIBlurEffect
    var blurEffectView:UIVisualEffectView
    var tapCloseDropDownMenu: UITapGestureRecognizer
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.shadowOpacity = 0.8
        topView.layer.shadowOffset = CGSize(width: 2, height: 0)
        topView.layer.shadowOpacity = 0.8
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openAccountView", name: "openAccountView", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openOrderView", name: "openOrderView", object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        blurEffect = UIBlurEffect(style: .Dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        tapCloseDropDownMenu = UITapGestureRecognizer()
        super.init(coder: aDecoder)
        tapCloseDropDownMenu = UITapGestureRecognizer(target: self, action: "hidDropDownMenu")
    }

    
    @IBAction func menu(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
        
    }
    
    func openMenu(){
        NSNotificationCenter.defaultCenter().postNotificationName("openMenu", object: nil)
    }
    
    func dismissMenu(){
            NSNotificationCenter.defaultCenter().postNotificationName("closeMenuViaNotification", object: nil)
    }
    
    func openAccountView(){
        self.performSegueWithIdentifier("account", sender: nil)
    }
    
    func openOrderView(){
        self.performSegueWithIdentifier("order", sender: nil)
    }

    
    
    @IBAction func chooseAddress(sender: AnyObject) {
        //let address = ["Minzu University of China", "University of Hong Kong", "Why show your weakness"]
        var locations:[String]
        if let location = Account.sharedManager.location {
            locations = location
        }
        else{
            locations = ["No used location"]
        }
        
        if (dropDownAddressButton == nil){
            let cellHeight:CGFloat = 40;
            let dropDownFrameHeight = cellHeight * CGFloat(locations.count)
            dropDownAddressButton = DropDownButton(button: dropDownAddressSender, cellHeight: cellHeight, height: dropDownFrameHeight, array: locations)
            dropDownAddressButton?.delegate = self
            view.addSubview(blurEffectView)
            view.addGestureRecognizer(tapCloseDropDownMenu)
            blurEffectView.frame = CGRectMake(view.bounds.origin.x, view.bounds.origin.y + topView.frame.size.height, view.frame.size.width, view.frame.size.height - topView.frame.size.height)
            
        } else {
            dropDownAddressButton?.hideDropDown(dropDownAddressSender as UIButton)
            dropDownAddressButton = nil
            blurEffectView.removeFromSuperview()
            view.removeGestureRecognizer(tapCloseDropDownMenu)
        }
    }
    
    func hidDropDownMenu(){
        dropDownAddressButton?.hideDropDown(dropDownAddressSender as UIButton)
        dropDownAddressButton = nil
        blurEffectView.removeFromSuperview()
        view.removeGestureRecognizer(tapCloseDropDownMenu)
    }
    
    func dropDownMenuClicked(sender: DropDownButton) {
        blurEffectView.removeFromSuperview()
        print("you choose:\(sender.choosedString)")
        dropDownAddressButton = nil
    }
}
