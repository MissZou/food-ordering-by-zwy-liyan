//
//  Account.swift
//  FoodPersistantLayer
//
//  Created by MoonSlides on 16/2/5.
//  Copyright © 2016年 李龑. All rights reserved.
//

import Alamofire

protocol AccountDelegate {
    func finishCreateAccount(result:NSDictionary, account: Account)
    func finishLogin(result:NSDictionary, account: Account)
}

class Account: NSObject {
    
    let baseUrl = "http://localhost:8080/user/";
    var delegate:AccountDelegate?
    
    var email:String
    var name:String
    var phone:String
    var password:String
    var photoUrl:String?
    var deliveryAddress:[String]?
    var accountId:String?
    var location:[String]?
    var token:String?
    //static var sharedManager: Account
    override init() {
        email = ""
        password = ""
        name = ""
        phone = ""
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
        
        Alamofire.request(.POST, "\(baseUrl)"+"register", parameters: params, encoding: .JSON).responseJSON { response in
//            let dataString = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
//            print(dataString!)
//            print(NSString(data: response.request!.HTTPBody!, encoding: NSUTF8StringEncoding)!)
            
            if let json = response.result.value {
                if let json = response.result.value
                {
                    if let code = json.objectForKey("code") {
                        if code as! Int  == 200 {
                            self.delegate?.finishCreateAccount(json as! NSDictionary, account: model)
                        }
                        else {
                            print("Account has been used")
                            self.delegate?.finishCreateAccount(json as! NSDictionary, account: model)
                        }
                    }
                    
                }
            }
        }
    }
    
    func login(model:Account){
        let params:[String : AnyObject] = [
            "email" : model.email,
            "password" : model.password
            ]
        Alamofire.request(.POST, "\(baseUrl)"+"login", parameters: params, encoding: .JSON).responseJSON { response in

            if let json = response.result.value
            {
                if let code = json.objectForKey("code") {
                    if code as! Int  == 200 {
                        self.delegate?.finishLogin(json as! NSDictionary, account: model)
                    }
                    else {
                        print("wrong email or password")
                        self.delegate?.finishLogin(json as! NSDictionary, account: model)
                    }
                }

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
            print(deliveryAddress)
            self.deliveryAddress = deliveryAddress as? [String]
        }
        
        if let location = data.objectForKey("location") {
            self.location = location as? [String]
        }
    }
}
