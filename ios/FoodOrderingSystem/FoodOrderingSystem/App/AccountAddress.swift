    //
//  AccountAddress.swift
//  FoodOrderingSystem
//
//  Created by MoonSlides on 16/3/1.
//  Copyright © 2016年 李龑. All rights reserved.
//

import UIKit

class AccountAddress: UIViewController, UITableViewDelegate, UITableViewDataSource, AccountDelegate {

    @IBOutlet weak var backButton1: UIButton!
    @IBOutlet weak var backButton2: UIButton!
    @IBOutlet weak var addAddressButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let myAccount = Account.sharedManager

    override func viewDidLoad() {
        super.viewDidLoad()
        topView.layer.shadowOffset = CGSize(width: 0, height: 5)
        topView.layer.shadowOpacity = 0.3
        buttonView.layer.shadowOpacity = 0.3
        buttonView.layer.shadowOffset = CGSize(width: 2, height: -3)
        tableView.delegate = self
        tableView.dataSource = self
        myAccount.delegate = self
        backButton1.addTarget(self, action: "holdDown", forControlEvents: UIControlEvents.TouchDown)
        backButton2.addTarget(self, action: "holdDown", forControlEvents: UIControlEvents.TouchDown)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        myAccount.refreshAccountData()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func holdDown(){
        dispatch_async(dispatch_get_main_queue(), {
            self.backButton1.highlighted = true
            self.backButton2.highlighted = true
        })
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        print(backButton1.selected)
        print(backButton1.highlighted)
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Table view data source

     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let addresses = myAccount.deliveryAddress {
            return addresses.count
        }
        return 0
    }


     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //print("cellForRowAtIndexPath")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("address", forIndexPath: indexPath) as! AddressCell
        if (indexPath.row == 0){
            cell.backgroundColor = UIColor(red: 250/255, green: 114/255, blue: 109/255, alpha: 1)
            cell.defaultImage.hidden = false
        }
        else{
            cell.backgroundColor = UIColor.whiteColor()
            cell.defaultImage.hidden = true
        }
        
        if let addresses = myAccount.deliveryAddress {
            let addr = addresses[indexPath.row]
                if let name = addr["name"] {
                    cell.name.text = name as? String
                }
                if let address = addr["addr"] {
                    cell.address.text = address as? String
                }
                if let phone = addr["phone"] {
                    cell.phone.text = phone as? String
                }
        }

        
        return cell
    }

    func finishRefresh() {
        tableView.reloadData()
    }
 
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("addressCell", sender: tableView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addressCell" {
            let indexPath = self.tableView.indexPathForSelectedRow
            let detailViewController = segue.destinationViewController as! AddAddressViewController
            if let addresses = myAccount.deliveryAddress {
                let addr = addresses[indexPath!.row]
                if let name = addr["name"] {
                    detailViewController.passName = name as? String
                }
                if let address = addr["addr"] {
                    detailViewController.passAddress = address as? String
                }
                if let phone = addr["phone"] {
                    detailViewController.passPhone = phone as? String
                }
                if let addrId = addr["_id"] {
                    detailViewController.passAddrId = addrId as? String
                }
                
                detailViewController.isEditing = true
            }
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
