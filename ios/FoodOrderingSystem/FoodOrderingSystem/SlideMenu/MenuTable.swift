//
//  LeftSildeMenu.swift
//  SlideMenu
//
//  Created by MoonSlides on 16/1/31.
//  Copyright © 2016年 李龑. All rights reserved.
//

import UIKit

class MenuTable: UITableViewController {
    let menuOptions = ["Open Modal", "Open Push", "Account"]
    
    
}

extension MenuTable {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            // ContainerVC.swift listens for this
            NSNotificationCenter.defaultCenter().postNotificationName("openAccountView", object: nil)
        case 1:
            // Both FirstViewController and SecondViewController listen for this
            NSNotificationCenter.defaultCenter().postNotificationName("openOrderView", object: nil)
        case 2:
            //performSegueWithIdentifier("account", sender: nil)
           break
        default:
            print("indexPath.row:: \(indexPath.row)")
        }
        
        // also close the menu
        NSNotificationCenter.defaultCenter().postNotificationName("closeMenuViaNotification", object: nil)
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomizeTableCell
        cell.tableLabel.text = menuOptions[indexPath.row]
        return cell
    }

}