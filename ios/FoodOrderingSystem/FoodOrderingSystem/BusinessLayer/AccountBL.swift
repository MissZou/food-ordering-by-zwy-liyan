//
//  AccountBL.swift
//  FoodBusinessLogicalLayer
//
//  Created by MoonSlides on 16/2/5.
//  Copyright © 2016年  - -!!!. All rights reserved.
//

import FoodPersistantLayer
//import Account//Can not import account, can not build

class AccountBL: NSObject, AccountDelegate {

    func createAccount(model: Account){
        let model = Account.sharedManager
        model.delegate = self
        model.createAccount(model)
    }
    
    
}
