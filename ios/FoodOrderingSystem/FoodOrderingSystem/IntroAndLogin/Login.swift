//
//  Login.swift
//  FoodOrderingSystem
//
//  Created by MoonSlides on 16/1/17.
//  Copyright © 2016年 李龑. All rights reserved.
//

import UIKit



class Login: UIViewController {

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var btnForgetPassword: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    let MyKeychainWrapper = KeychainWrapper()
    let loginButtonTag = 0
    let hasLoginButtonTag = 1
    
    var accountBL: AccountBL?
    var account: Account?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLayoutStyle()
    
        account = Account.sharedManager
        accountBL = AccountBL()
        accountBL?.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard"))
        view.addGestureRecognizer(tap)

        self.userName.delegate = self
        self.password.delegate = self
        //self.setNeedsStatusBarAppearanceUpdate()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginSuccessed", name: "loginSuccessed", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginFailed", name: "loginFailed", object: nil)
        
        //checkLoginStatus()
    }
    
    deinit {
        //NSNotificationCenter.defaultCenter().removeObserver(self, name: "loginSuccess", object: nil)
        //NSNotificationCenter.defaultCenter().removeObserver(self, name: "loginFailed", object: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func dismissKeyboard(){
        userName.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    func configLayoutStyle(){
        userName.layer.borderWidth = 1.0
        password.layer.borderWidth = 1.0
        userName.layer.borderColor = UIColor.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).CGColor
        password.layer.borderColor = UIColor.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).CGColor
        
        btnSignUp.layer.borderColor = UIColor.init(red: 76/255, green: 76/255, blue: 76/255, alpha: 1).CGColor
        btnSignUp.layer.borderWidth = 1.0
        btnSignUp.layer.cornerRadius = 4.0
    }
    
    @IBAction func dismissLoginDialog(sender: AnyObject) {
       dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func forgetPassword(sender: AnyObject) {
        
    }
    
    @IBAction func login(sender: AnyObject) {
        //print(NSUserDefaults.standardUserDefaults().dictionaryRepresentation())
        if (userName.text! == "" || password.text! == ""){
        let alertView = UIAlertController(title: "Login Problem",
            message: "Wrong username or password." as String, preferredStyle:.Alert)
            self.presentViewController(alertView, animated: true, completion: nil)
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alertView.addAction(okAction)
            return
        }
        
        
        let hasLoginKey = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
        
//        if hasLoginKey == false {
//            print("hasLoginKye false")
//            NSUserDefaults.standardUserDefaults().setValue(self.userName.text!, forKey: "username")
//        }

        account?.email = userName.text!
        account?.password = password.text!
        accountBL?.login(account!)
    }
    
    func checkLoginStatus(){
        if let token = account?.token {
            account?.checkLoginStatus()
        }
    }
    
    
    func loginSuccessed() {

        //NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoginKey")
        if let token = account?.token {
            NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token")
            NSUserDefaults.standardUserDefaults().setValue(userName.text!, forKey: "email")
            MyKeychainWrapper.mySetObject(password.text!, forKey:kSecValueData)
            MyKeychainWrapper.writeToKeychain()
        }
        NSUserDefaults.standardUserDefaults().synchronize()
        //print(NSUserDefaults.standardUserDefaults().dictionaryRepresentation())
        performSegueWithIdentifier("MainMenu", sender: nil)
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

extension Login: AccountBLDelegate {
    func blFinishLogin(result:NSDictionary, account: Account) {
        if let code = result.objectForKey("code") {
            if code as! Int == 200 {
                
                account.testKeyChain()
                loginSuccessed()
                
            }
            else {
                NSNotificationCenter.defaultCenter().postNotificationName("loginFailed", object: nil)
            }
        }

    }
    
}
