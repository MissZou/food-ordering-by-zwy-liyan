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
    optional func blFinishCreateAccount(result:NSDictionary, account: Account)
    optional func blFinishLogin(result:NSDictionary, account:Account)
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

}

extension AccountBL {
    func finishCreateAccount(result:NSDictionary, account: Account) {
        self.delegate?.blFinishCreateAccount!(result, account: account)
    }
    
    func finishLogin(result:NSDictionary, account:Account) {
        self.delegate?.blFinishLogin!(result, account: account)
    }
}