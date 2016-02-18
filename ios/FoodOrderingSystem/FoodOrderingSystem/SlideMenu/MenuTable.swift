//
//  LeftSildeMenu.swift
//  SlideMenu
//
//  Created by MoonSlides on 16/1/31.
//  Copyright © 2016年 李龑. All rights reserved.
//

import UIKit

class MenuTable: UITableViewController {
    let menuOptions = ["Account", "Menu", "Schedule", "Favorite", "Log Out"]

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.prefersStatusBarHidden()
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func logout(){
        let myKeyChain = Account.sharedManager.myKeychain
        do {
            let email = try myKeyChain.getString("fosAccount")
            let password = try myKeyChain.getString("fosPassword")
            let token = try myKeyChain.getString("fosToken")
            if(email != nil && password != nil && token != nil) {
                 print(email! + password! + token!)
            }
        } catch let error {
            print(error)
        }
        
        do {
            try myKeyChain.remove("fosAccount")
            try myKeyChain.remove("fosPassword")
            try myKeyChain.remove("fosToken")
        } catch let error {
            print("error: \(error)")
        }
     
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension MenuTable {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            NSNotificationCenter.defaultCenter().postNotificationName("openAccountView", object: nil)
        case 1:
            NSNotificationCenter.defaultCenter().postNotificationName("closeMenuViaNotification", object: nil)
        case 2:
            NSNotificationCenter.defaultCenter().postNotificationName("openOrderView", object: nil)
        case 3:
            print("favorite + \(indexPath.row)")
        case 4:
            logout()
            print("logout")
        default:
            print("indexPath.row:: \(indexPath.row)")
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! LeftMenuTableCell
        cell.tableLabel.text = menuOptions[indexPath.row]
        //cell.tableIcon.image = UIImage(named: menuOptionsIcons[indexPath.row])
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        
        return (cell?.bounds.size.height)! 
    }

}