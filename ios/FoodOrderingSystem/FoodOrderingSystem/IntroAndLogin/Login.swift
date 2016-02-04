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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginSuccessed", name: "loginSuccessed", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginFailed", name: "loginFailed", object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "loginSuccess", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "loginFailed", object: nil)
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
        performSegueWithIdentifier("Index", sender: nil)

        //        let params:[String : AnyObject] = [
//            "email" : account.text!,
//            "password" : password.text!
//        ]
//
//        let networkHlep = NetworkHelp()
//        //networkHlep.sendPostRequest("login",params: params)
//        networkHlep.login("login",params: params)
    }
    
    func loginSuccessed() {
        performSegueWithIdentifier("Index", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Index" {
            let slideMenu = segue.destinationViewController as! SlideMenu
            //slideMenu.scrollView.setContentOffset(CGPoint(x:slideMenu.leftMenuWidth, y: 0), animated: false)
        }
    }
    
    func loginFailed() {
        let alertController = UIAlertController(title: "Login Failed", message: "Wrong email or password", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

extension Login: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
