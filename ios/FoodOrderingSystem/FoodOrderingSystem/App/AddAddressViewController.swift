//
//  AddAddressViewController.swift
//  FoodOrderingSystem
//
//  Created by MoonSlides on 16/3/2.
//  Copyright © 2016年 李龑. All rights reserved.
//

import UIKit

class AddAddressViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var backButton1: UIButton!
    @IBOutlet weak var backButton2: UIButton!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    
    var passName:String?
    var passPhone:String?
    var passAddress:String?
    var passAddrId:String?
    var isEditing:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backButton1.addTarget(self, action: "holdDown", forControlEvents: UIControlEvents.TouchDown)
        backButton2.addTarget(self, action: "holdDown", forControlEvents: UIControlEvents.TouchDown)

        let tap = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard"))
        view.addGestureRecognizer(tap)
        if let name = passName {
            self.name.text = name
        }
        if let phone = passPhone {
            self.phone.text = phone
        }
        if let address = passAddress {
            self.address.text = address
        }
        
        deleteButton.layer.cornerRadius = 5
        deleteButton.hidden = true
        deleteButton.enabled = false
        if let isEditing = isEditing {
            if isEditing {
                deleteButton.hidden = false
                deleteButton.enabled = true
            }
        }
    }

    func holdDown(){
        dispatch_async(dispatch_get_main_queue(), {
            self.backButton1.highlighted = true
            self.backButton2.highlighted = true
        })
    }
    
    func dismissKeyboard(){
        name.resignFirstResponder()
        phone.resignFirstResponder()
        address.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dismissViewControllerWithAnimation(){
        let transition = CATransition()
        transition.duration = 0.35
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromLeft
        
        let containerView = self.view.window
        containerView?.layer.addAnimation(transition, forKey: nil)
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func backButton(sender: AnyObject) {
        dismissViewControllerWithAnimation()
        //dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func cancelButton(sender: AnyObject) {
        presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func saveAddress(sender: AnyObject) {
        if let editing = isEditing {
            if (editing){
                
                if let addrId = passAddrId {
                    print(addrId)
                let addressDic = ["name":name.text!,"phone":phone.text!,"address":address.text!,"type":"0","addrId":addrId]
                Account.sharedManager.address(Account.requestMethod.POST, address: addressDic as NSDictionary)
                    dismissViewControllerWithAnimation()
                }
            }
            
        } else {
             let addressDic = ["name":name.text!,"phone":phone.text!,"address":address.text!,"type":"0"]
            Account.sharedManager.address(Account.requestMethod.PUT, address: addressDic as NSDictionary)
            dismissViewControllerWithAnimation()
        }
    }
    
    @IBAction func deleteAddress(sender: AnyObject) {
             let addressDic = ["name":name.text!,"phone":phone.text!,"address":address.text!,"type":"0","addrId":passAddrId!]
        Account.sharedManager.address(Account.requestMethod.DELETE, address: addressDic as NSDictionary)
        dismissViewControllerWithAnimation()

    }

}
