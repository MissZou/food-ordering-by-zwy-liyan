//
//  Account.swift
//  FoodPersistantLayer
//
//  Created by MoonSlides on 16/2/5.
//  Copyright © 2016年 李龑. All rights reserved.
//

import Alamofire

protocol AccountDelegate {
    func finishCreateAccount(status:String)
    func finishLogin(status:String)
}

class Account: NSObject {
    
    let baseUrl = "http://localhost:8080/api/";
    var delegate:AccountDelegate?
    
    var email:String
    var name:String
    var phone:String
    var password:String
    var photoUrl:String?
    var deliveryAddress:String?
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
    
    func createAccount(email:String, password:String, name:String, phone:String){
        let params:[String : AnyObject] = [
            "email" : email,
            "password" : password,
            "phone" : phone,
            "name" : name
        ]
        
        Alamofire.request(.POST, "\(baseUrl) + register", parameters: params, encoding: .JSON).responseData { response in
            let dataString = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
            print(dataString!)
            print(NSString(data: response.request!.HTTPBody!, encoding: NSUTF8StringEncoding)!)
            if (dataString! == "ok"){
                self.delegate?.finishCreateAccount("ok")
            }
            else {
                self.delegate?.finishCreateAccount(dataString! as String)
            }
        }
    }
    
    func login(email:String, password:String){
        let params:[String : AnyObject] = [
            "email" : email,
            "password" : password
            ]
        Alamofire.request(.POST, "\(baseUrl) + login", parameters: params, encoding: .JSON).responseData { response in
            let dataString = NSString(data: response.data!, encoding: NSUTF8StringEncoding)
            print(dataString!)
            print(NSString(data: response.request!.HTTPBody!, encoding: NSUTF8StringEncoding)!)
            if (dataString! == "true"){
                self.delegate?.finishLogin("ok")
            }
            else {
                self.delegate?.finishLogin(dataString! as String)
            }
        }

    }
}
