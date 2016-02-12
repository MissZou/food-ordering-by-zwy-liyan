//
//  AccountBL.swift
//  FoodBusinessLogicalLayer
//
//  Created by MoonSlides on 16/2/5.
//  Copyright © 2016年  - -!!!. All rights reserved.
//

import FoodPersistantLayer
//import Account//Can not import account, can not build

@objc protocol AccountBLDelegate {
    optional func blFinishCreateAccount(status: String, account: Account)
    optional func blFinishLogin(status:String, account:Account)
}

class AccountBL: NSObject, AccountDelegate {

    var delegate:AccountBLDelegate?
    
    func createAccount(model: Account){
        let account = Account.sharedManager
        account.delegate = self
        account.createAccount(model)
    }
    
    func login(model: Account) {
        let account = Account.sharedManager
        account.delegate = self
        account.login(model)
    }
    
    func loginTestBl(email:String, password:String){
        let account = Account.sharedManager
        account.delegate = self
        account.loginTest(email, password: password)
    }

}

extension AccountBL {
    func finishCreateAccount(status: String, account: Account) {
        self.delegate?.blFinishCreateAccount!(status, account: account)
    }
    
    func finishLogin(status: String, account:Account) {
        self.delegate?.blFinishLogin!(status, account: account)
    }
}