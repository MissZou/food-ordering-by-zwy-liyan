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
    optional func finishRefresh()
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
    var deliveryAddress:[[String:AnyObject]]?
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

    func refreshAccountData(){
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
                            //print("token verify success")
                            self.delegate?.finishRefresh!()
                        }
                        else {
                            
                            print("token problem")
                            do {
                                let email = try self.myKeychain.getString("fosAccount")
                                let password = try self.myKeychain.getString("fosPassword")
                                if (email != nil && password != nil){
                                    
                                    let params:[String : AnyObject] = [
                                        "email" : email!,
                                        "password" : password!
                                    ]
                    Alamofire.request(.POST, "\(self.baseUrl)"+"login", parameters: params, encoding: .JSON).responseJSON { response in
                                            
                        if let json = response.result.value
                            {
                            if let success = json.objectForKey("success") {
                                if success as! NSObject  == true                                        {
                                    self.updateAccountData(json as! NSDictionary)
                                }
                            }
                        }
                    }
                                }
                            } catch let error{
                                print(error)
                            }
                        }
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
        

        if let addresses = data["address"] as? [[String:AnyObject]] { // let the default address, type == 1 to be the first address in deliveryAddress array
            self.deliveryAddress = addresses
            if let addresses = self.deliveryAddress {
                var count = 0
                for addr in addresses{
                    
                    if let type = addr["type"]{
                        //print(type)
                        if (type as! NSObject == "1") {
                            //print("default address")
                            self.deliveryAddress?.removeAtIndex(count)
                            self.deliveryAddress?.insert(addr, atIndex: 0)
                        }
                    }
                count++
                }
            }
        }
        
        if let location = data.objectForKey("location") {
            self.location = location as? [String]
        }
        self.delegate?.finishRefresh!()
    }
    
    func printAccount(data:NSDictionary) {
        if let token = data.objectForKey("token"){
            self.token = token as? String
            print(token)
        }
        
        if let accountId = data.objectForKey("accountId"){
            self.accountId = accountId as? String
            print(accountId)
        }
        
        if let email = data.objectForKey("email"){
            self.email = email as! String
            print(email)
        }
        
        if let phone = data.objectForKey("phone"){
            self.phone = phone as! String
            print(phone)
        }
        
        if let name = data.objectForKey("name"){
            self.name = name as! String
            print(name)
        }
        
        if let photoUrl = data.objectForKey("photoUrl") {
            self.photoUrl = photoUrl as? String
            print(photoUrl)
        }
        
        if let deliveryAddress = data.objectForKey("address") {
            //print(deliveryAddress)
            
            print(deliveryAddress)

        }
        
        if let location = data.objectForKey("location") {
            self.location = location as? [String]
            print(location)
        }

    }
    
    func checkLoginStatus(){
        if let token = self.token {
            let params:[String : AnyObject] = [
                "token" : token
            ]
            
            Alamofire.request(.POST, "\(baseUrl)"+"account", parameters: params, encoding: .JSON)
                .responseJSON { response in
                    
            var json:NSDictionary?
            do {
                json = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments) as? NSDictionary
            } catch {
                print(error)
            }
            
            if let success = json!.objectForKey("success") {
                if success as! NSObject == true {
                    self.updateAccountData(json!)
                   // self.printAccount(json as! NSDictionary)
                    self.delegate?.finishLogin!(json!, account: Account.sharedManager)
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
    
    
    func address(operation: requestMethod, address:NSDictionary){
        if(operation == .PUT) { //add address
            if let token = self.token {
                let params:[String : AnyObject] = [
                    "token":token,
                    "address" : address.objectForKey("address")!,
                    "name" : address.objectForKey("name")!,
                    "phone": address.objectForKey("phone")!,
                    "type":address.objectForKey("type")!
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
                    "addrId" : address.objectForKey("addrId")!,
                    "address" : address.objectForKey("address")!,
                    "name" : address.objectForKey("name")!,
                    "phone": address.objectForKey("phone")!,
                    "type":address.objectForKey("type")!
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
        else if (operation == .POST) {
            if let token = self.token {
                let params:[String : AnyObject] = [
                    "token":token,
                    "addrId" : address.objectForKey("addrId")!,
                    "address" : address.objectForKey("address")!,
                    "name" : address.objectForKey("name")!,
                    "phone": address.objectForKey("phone")!,
                    "type":address.objectForKey("type")!
                    ]
                print(params)
                Alamofire.request(.POST, "\(baseUrl)"+"account/address", parameters: params, encoding: .JSON)
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
