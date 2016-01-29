//
//  Login.swift
//  FoodOrderingSystem
//
//  Created by MoonSlides on 16/1/17.
//  Copyright © 2016年 李龑. All rights reserved.
//

import UIKit

class Login: UIViewController {

    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var btnForgetPassword: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        account.layer.borderWidth = 1.0
        password.layer.borderWidth = 1.0
        account.layer.borderColor = UIColor.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).CGColor
        password.layer.borderColor = UIColor.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).CGColor
        
        btnSignUp.layer.borderColor = UIColor.init(red: 76/255, green: 76/255, blue: 76/255, alpha: 1).CGColor
        btnSignUp.layer.borderWidth = 1.0
        btnSignUp.layer.cornerRadius = 4.0
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard"))
        view.addGestureRecognizer(tap)

        self.account.delegate = self
        self.password.delegate = self
        //self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func dismissKeyboard(){
        account.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    @IBAction func dismissLoginDialog(sender: AnyObject) {
       dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func forgetPassword(sender: AnyObject) {
        
    }
    
    @IBAction func login(sender: AnyObject) {
        let params:[String : AnyObject] = [
            "email" : account.text!,
            "password" : password.text!
        ]

        let networkHlep = NetworkHelp()
        //networkHlep.sendPostRequest("login",params: params)
        networkHlep.login("login",params: params)
    }
    
}

extension Login: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
