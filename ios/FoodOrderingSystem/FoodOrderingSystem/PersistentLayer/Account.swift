//
//  Account.swift
//  FoodPersistantLayer
//
//  Created by MoonSlides on 16/2/5.
//  Copyright © 2016年 李龑. All rights reserved.
//

import Alamofire
import KeychainAccess

@objc protocol AccountDelegate {
   optional func finishCreateAccount(result:NSDictionary, account: Account)
   optional func finishLogin(result:NSDictionary, account: Account)
}

class Account: NSObject {
    
    let baseUrl = "http://localhost:8080/user/";
//    let baseUrl = "http://175.159.182.249:8080/user/"
    var delegate:AccountDelegate?
    //let myKeychainItemWrapper = KeychainItemWrapper()
    var myKeychain:Keychain
    
    var email:String
    var name:String
    var phone:String
    var password:String
    var photoUrl:String?
    var deliveryAddress:[String]?
    var accountId:String?
    var location:[String]?
    var token:String?
    
    enum requestMethod {
        case DELETE
        case POST
        case PUT
        case GET
    }
    
    //static var sharedManager: Account
    override init() {
        email = ""
        password = ""
        name = ""
        phone = ""
        myKeychain = Keychain(service: "FoodOrderingSystem")
    }
    
    class var sharedManager:Account {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var sharedManager: Account?
        }
        dispatch_once(&Static.onceToken){
            Static.sharedManager = Account()
        }
        
        return Static.sharedManager!
    }
    
    func createAccount(model: Account){
        
        let params:[String : AnyObject] = [
            "email" : model.email,
            "password" : model.password,
            "phone" : model.phone,
            "name" : model.name
        ]
        
        Alamofire.request(.POST, "\(baseUrl)"+"register", parameters: params, encoding: .JSON)
            .responseJSON { response in
//            let dataString = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
//            print(dataString!)
//            print(NSString(data: response.request!.HTTPBody!, encoding: NSUTF8StringEncoding)!)
            

                if let json = response.result.value
                {
                    if let code = json.objectForKey("code") {
                        if code as! Int  == 200 {
                            self.updateAccountData(json as! NSDictionary)
                            self.delegate?.finishCreateAccount!(json as! NSDictionary, account: model)
                        }
                        else {
                            print("Account has been used")
                            self.delegate?.finishCreateAccount!(json as! NSDictionary, account: model)
                        }
                    }
                    
                }
            
        }
            .response { response in
                if response.3 != nil {
                    print(response.3)
                    let falseInfo = NSDictionary(object: false, forKey: "success")
                    self.delegate?.finishLogin!(falseInfo, account: Account.sharedManager)
                }
        }

    }
    
    func login(model:Account){
        let params:[String : AnyObject] = [
            "email" : model.email,
            "password" : model.password
            ]
        Alamofire.request(.POST, "\(baseUrl)"+"login", parameters: params, encoding: .JSON)
            .responseJSON { response in
            
            if let json = response.result.value
            {
                if let success = json.objectForKey("success") {
                    if success as! NSObject  == true {
                        self.updateAccountData(json as! NSDictionary)
                        self.delegate?.finishLogin!(json as! NSDictionary, account: model)
                        
                    }
                    else {
                        print("wrong email or password")
                        let falseInfo = NSDictionary(object: false, forKey: "success")
                        self.delegate?.finishLogin!(falseInfo, account: model)
                    }
                }

            }
        }
            .response { response in
                if response.3 != nil {
                    print(response.3)
                    let falseInfo = NSDictionary(object: false, forKey: "success")
                    self.delegate?.finishLogin!(falseInfo, account: Account.sharedManager)
                }
        }

    }

    func updateAccountData(data:NSDictionary){
        if let token = data.objectForKey("token"){
            self.token = token as? String
        }
        
        if let accountId = data.objectForKey("accountId"){
            self.accountId = accountId as? String
        }
        
        if let email = data.objectForKey("email"){
            self.email = email as! String
        }
        
        if let phone = data.objectForKey("phone"){
            self.phone = phone as! String
        }
        
        if let name = data.objectForKey("name"){
            self.name = name as! String
        }
        
        if let photoUrl = data.objectForKey("photoUrl") {
            self.photoUrl = photoUrl as? String
        }
        
        if let deliveryAddress = data.objectForKey("address") {
            //print(deliveryAddress)
            self.deliveryAddress = deliveryAddress as? [String]
        }
        
        if let location = data.objectForKey("location") {
            self.location = location as? [String]
        }
    }
    
    func checkLoginStatus(){
        if let token = self.token {
            let params:[String : AnyObject] = [
                "token" : token
            ]
            
            Alamofire.request(.POST, "\(baseUrl)"+"account", parameters: params, encoding: .JSON)
                .responseJSON { response in
                if let json = response.result.value
                {
                    if let success = json.objectForKey("success") {
                        if success as! NSObject == true {
                            self.updateAccountData(json as! NSDictionary)
                            self.delegate?.finishLogin!(json as! NSDictionary, account: Account.sharedManager)
                            //print("token verify success")
                        }
                        else {
                            print("token problem")

                            
                            do {
                                let email = try self.myKeychain.getString("fosAccount")
                                let password = try self.myKeychain.getString("fosPassword")
                                if (email != nil && password != nil){
                                    self.email = email!
                                    self.password = password!
                                    self.login(self)
                                }
                                else{
                                    let falseInfo = NSDictionary(object: false, forKey: "success")
                                    self.delegate?.finishLogin!(falseInfo, account: Account.sharedManager)
                                }
                            } catch let error{
                                print(error)
                            }
                        }
                    }
                    
                }
            }
                .response { response in
                    if response.3 != nil {
                        print(response.3)
                        let falseInfo = NSDictionary(object: false, forKey: "success")
                        self.delegate?.finishLogin!(falseInfo, account: Account.sharedManager)
                    }
            }
            
        }
        else{
            do {
                let email = try self.myKeychain.getString("fosAccount")
                let password = try self.myKeychain.getString("fosPassword")
                if (email != nil && password != nil){
                    self.email = email!
                    self.password = password!
                    self.login(self)
                }
                else{
                    let falseInfo = NSDictionary(object: false, forKey: "success")
                    self.delegate?.finishLogin!(falseInfo, account: Account.sharedManager)
                }
            } catch let error{
                print(error)
            }
           
            
        }
    }
    
    
    func address(operation: requestMethod, address:String){
        if(operation == .PUT) { //add address
            if let token = self.token {
                let params:[String : AnyObject] = [
                    "token":token,
                    "address" : address
                ]
            Alamofire.request(.PUT, "\(baseUrl)"+"account/address", parameters: params, encoding: .JSON)
                .responseJSON { response in
                    
                    
                    if let json = response.result.value
                    {
                        if let success = json.objectForKey("success") {
                            if success as! NSObject == true {
                                self.updateAccountData(json as! NSDictionary)
                            }
                        }
                        
                    }
                }
                .response { response in
                    if response.3 != nil {
                        print(response.3)
                    }
                }
            }
        }
        else if (operation == .DELETE){
            if let token = self.token {
                let params:[String : AnyObject] = [
                    "token":token,
                    "address" : address
                ]
                Alamofire.request(.DELETE, "\(baseUrl)"+"account/address", parameters: params, encoding: .JSON)
                    .responseJSON { response in
                        
                        
                        if let json = response.result.value
                        {
                            if let success = json.objectForKey("success") {
                                if success as! NSObject == true {
                                    self.updateAccountData(json as! NSDictionary)
                                }
                            }
                        }
                    }
                    .response { response in
                        if response.3 != nil {
                            print(response.3)
                        }
                }
            }
        }
    }
    
    func location(operation: requestMethod, location:String){
        if(operation == .PUT) { //add address
            if let token = self.token {
                let params:[String : AnyObject] = [
                    "token":token,
                    "location" : location
                ]
                Alamofire.request(.PUT, "\(baseUrl)"+"account/location", parameters: params, encoding: .JSON)
                    .responseJSON { response in
                        if let json = response.result.value
                        {
                            if let success = json.objectForKey("success") {
                                if success as! NSObject == true {
                                    self.updateAccountData(json as! NSDictionary)
                                }
                            }
                            
                        }
                    }
                    .response { response in
                        if response.3 != nil {
                            print(response.3)
                        }
                }
            }
        }
        else if (operation == .DELETE){
            if let token = self.token {
                let params:[String : AnyObject] = [
                    "token":token,
                    "location" : location
                ]
                Alamofire.request(.DELETE, "\(baseUrl)"+"account/location", parameters: params, encoding: .JSON)
                    .responseJSON { response in
                        if let json = response.result.value
                        {
                            if let success = json.objectForKey("success") {
                                if success as! NSObject == true {
                                    self.updateAccountData(json as! NSDictionary)
                                }
                            }
                        }
                    }
                    .response { response in
                        if response.3 != nil {
                            print(response.3)
                        }
                }
            }
        }
    }


}
