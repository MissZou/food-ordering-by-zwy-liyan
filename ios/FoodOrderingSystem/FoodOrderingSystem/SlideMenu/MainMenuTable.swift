//
//  MainMenuTable.swift
//  FoodOrderingSystem
//
//  Created by MoonSlides on 16/2/19.
//  Copyright © 2016年 李龑. All rights reserved.
//

import UIKit

class MainMenuTable: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.scrollEnabled = true
        tableView.alwaysBounceVertical = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        print("delete")
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("restaurantCell", forIndexPath: indexPath) as! RestaurantCell
        //cell.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 0.5)
        
        cell.starLabel.text = "asdf"
//        let textLabel = UILabel(frame: CGRectMake(40, 0, 100, 40))
//        textLabel.text = "search"
//        textLabel.font = UIFont(name: "HelveticaNeue-Light", size: 13)
//        textLabel.textColor = UIColor.whiteColor()
//        textLabel.textAlignment = .Left
//        
//        let imageView = UIImageView(frame: CGRectMake(5,10, 20, 20))
//        imageView.image = UIImage(named: "addGreen.png")
//        cell.contentView.addSubview(imageView)
//        cell.contentView.addSubview(textLabel)
//        
        return cell
    }

}
