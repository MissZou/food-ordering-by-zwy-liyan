//
//  DropDownMenu.swift
//  FoodOrderingSystem
//
//  Created by MoonSlides on 16/2/3.
//  Copyright © 2016年 李龑. All rights reserved.
//

import UIKit

protocol DropDownButtonDelegate {
    
    func dropDownMenuClicked(sender: DropDownButton)
    
}

class DropDownButton: UIView, UITableViewDelegate, UITableViewDataSource {

    var delegate: DropDownButtonDelegate?
    var choosedString:String?
    
    private var tableViewCellHeigh: CGFloat!
    private var dropDownTableView: UITableView?
    private var senderBtn: UIButton?
    private var dropDownList: Array<String>?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(button:UIButton, cellHeight: CGFloat,height:CGFloat,array:Array<String>) {
        self.init()
        tableViewCellHeigh = cellHeight
        self.showDropDown(button, height: height, buttonArray: array)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showDropDown(senderButton: UIButton, height: CGFloat , buttonArray: Array<String>)
    {
        senderBtn = senderButton
        
        
        let btn: CGRect = (senderButton.superview?.frame)!
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0)
        self.dropDownList = buttonArray
        self.layer.masksToBounds = false
        //self.layer.cornerRadius = 8
        //self.layer.shadowOffset = CGSizeMake(-5, 5)
        //self.layer.shadowRadius = 5
        //self.layer.shadowOpacity = 0.5
        
        dropDownTableView = UITableView(frame: CGRectMake(0, 0, btn.size.width, 0))
        dropDownTableView?.delegate = self
        dropDownTableView?.dataSource = self
        //dropDownTableView?.layer.cornerRadius = 5
        dropDownTableView?.backgroundColor = UIColor(red: 0.239, green: 0.239, blue: 0.239, alpha: 1)
        dropDownTableView?.separatorStyle = .None
        self.dropDownTableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "dropDownCell")//must
        
        UIView.beginAnimations(nil , context: nil)
        UIView.setAnimationDuration(0.5)
        self.frame = CGRectMake(btn.origin.x, btn.origin.y + btn.size.height, btn.size.width, height)
        dropDownTableView?.frame = CGRectMake(0, 0, btn.size.width, height)
        UIView.commitAnimations()
//        senderButton.superview?.addSubview(self)
        senderButton.superview?.superview?.superview?.superview?.superview?.addSubview(self)
        self.addSubview(dropDownTableView!)
    }
    
    func hideDropDown(senderButton: UIButton)
    {
        let btn :CGRect = (senderButton.superview?.frame)!
        UIView.beginAnimations(nil , context: nil)
        UIView.setAnimationDuration(0.5)
        self.frame = CGRectMake(btn.origin.x, btn.origin.y + btn.size.height, btn.size.width, 0)
        dropDownTableView?.frame = CGRectMake(0, 0, btn.size.width, 0)
        UIView.commitAnimations()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dropDownList!.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableViewCellHeigh
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView .dequeueReusableCellWithIdentifier("dropDownCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = dropDownList![indexPath.row] as String
        cell.textLabel?.font = UIFont.systemFontOfSize(12)
        cell.textLabel?.textAlignment = .Center
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.hideDropDown(senderBtn!)
        let cell:UITableViewCell = dropDownTableView!.cellForRowAtIndexPath(indexPath)!
        let buttonTitle = (cell.textLabel?.text)! + " ▾"
        senderBtn!.setTitle(buttonTitle, forState: UIControlState.Normal)
        self.choosedString = dropDownList![indexPath.row]
        self.delegate?.dropDownMenuClicked(self)
    }
}
