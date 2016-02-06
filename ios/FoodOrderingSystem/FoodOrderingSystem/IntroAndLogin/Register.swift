//
//  Register.swift
//  FoodOrderingSystem
//
//  Created by MoonSlides on 16/1/17.
//  Copyright © 2016年 李龑. All rights reserved.
//

import UIKit
import FoodBusinessLogicalLayer

class Register: UIViewController {

    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var btnsignUp: OrangeButton!
    
    @IBOutlet weak var privacy: UIButton!
    @IBOutlet weak var termsOfService: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.layer.borderWidth = 1.0
        email.layer.borderWidth = 1.0
        password.layer.borderWidth = 1.0
        phone.layer.borderWidth = 1.0
        
        name.layer.borderColor = UIColor.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).CGColor
        email.layer.borderColor = UIColor.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).CGColor
        password.layer.borderColor = UIColor.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).CGColor
        
        phone.layer.borderColor = UIColor.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).CGColor
        
        let attributes = [NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue]
        var attributeText = NSAttributedString(string: privacy.currentTitle!, attributes: attributes)
        privacy.titleLabel!.attributedText = attributeText
        
        attributeText = NSAttributedString(string: termsOfService.currentTitle!, attributes: attributes)
        termsOfService.titleLabel!.attributedText = attributeText
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard"))
        view.addGestureRecognizer(tap)
        
        self.name.delegate = self
        self.email.delegate = self
        self.password.delegate = self
        self.phone.delegate  = self
    }
    
    func dismissKeyboard(){
        email.resignFirstResponder()
        password.resignFirstResponder()
        name.resignFirstResponder()
        
        phone.resignFirstResponder()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func register(sender: AnyObject) {

        
        let params:[String : AnyObject] = [
            "email" : email.text!,
            "password" : password.text!,
            "phone" : phone.text!,
            "name" : name.text!
        ]
        
        let networkHlep = NetworkHelp()
        networkHlep.sendPostRequest("register",params: params)
        //var accountbl = AccountBL()
    }
    
    @IBAction func viewPrivacy(sender: AnyObject) {
        
    }
    @IBAction func viewTermsOfService(sender: AnyObject) {
        
    }

    @IBAction func backToLogin(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
}

extension Register: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}