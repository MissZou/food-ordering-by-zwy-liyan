//
//  MainMenuViewController.swift
//  SlideMenu
//
//  Created by MoonSlides on 16/1/31.
//  Copyright © 2016年 李龑. All rights reserved.
//

import UIKit



class MainMenuViewController: UIViewController, DropDownButtonDelegate {


    @IBOutlet var dropDownAddressSender: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var slideMenuButton: UIButton!
    
    var blurEffect:UIBlurEffect
    var blurEffectView:UIVisualEffectView
    var blurEffectForTable:UIVisualEffectView
    var tapCloseDropDownMenu: UITapGestureRecognizer
    var tapCloseSearchBar:UITapGestureRecognizer
    var dropDownAddressButton: DropDownButton?
    let cellHeight:CGFloat = 40;

    
    var searchController = UISearchController(searchResultsController: nil)
    var searchTableView:UITableView?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.shadowOpacity = 0.8
        topView.layer.shadowOffset = CGSize(width: 2, height: 0)
        topView.layer.shadowOpacity = 0.8
//        buttonView.layer.shadowOpacity = 0.8
//        buttonView.layer.shadowOffset = CGSize(width: 2, height: 0)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openAccountView", name: "openAccountView", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openOrderView", name: "openOrderView", object: nil)
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        //searchController.searchBar.scopeButtonTitles = ["All", "Chocolate", "Hard", "Other"]
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //searchController.active = false
        //searchController.searchBar.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        blurEffect = UIBlurEffect(style: .Dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectForTable = UIVisualEffectView(effect: blurEffect)
        tapCloseDropDownMenu = UITapGestureRecognizer()
        tapCloseSearchBar = UITapGestureRecognizer()
        super.init(coder: aDecoder)
        tapCloseDropDownMenu = UITapGestureRecognizer(target: self, action: "hidDropDownMenu")
        tapCloseSearchBar = UITapGestureRecognizer(target: self, action: "searchBarCancelButtonClicked")
    }

    
    @IBAction func menu(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
        
    }
    
    func openMenu(){
        NSNotificationCenter.defaultCenter().postNotificationName("openMenu", object: nil)
    }
    
    func dismissMenu(){
            NSNotificationCenter.defaultCenter().postNotificationName("closeMenuViaNotification", object: nil)
    }
    
    func openAccountView(){
        self.performSegueWithIdentifier("account", sender: nil)
    }
    
    func openOrderView(){
        self.performSegueWithIdentifier("order", sender: nil)
    }

    
    
    @IBAction func chooseAddress(sender: AnyObject) {
        //let address = ["Minzu University of China", "University of Hong Kong", "Why show your weakness"]
        var locations:[String]
        Account.sharedManager.refreshAccountData()
        Account.sharedManager.delegate = nil
        if let location = Account.sharedManager.location {
            locations = location
            locations.insert("New Location", atIndex: 0)
        }
        else{
            locations = ["No used location"]
        }
        //locations = ["No used location"]
        if (dropDownAddressButton == nil){
            //let cellHeight:CGFloat = 40;
            let dropDownFrameHeight = cellHeight * CGFloat(locations.count)
            dropDownAddressButton = DropDownButton(button: dropDownAddressSender, cellHeight: cellHeight, height: dropDownFrameHeight, array: locations)
            dropDownAddressButton?.delegate = self
            blurEffectView.frame = CGRectMake(view.bounds.origin.x, view.bounds.origin.y + topView.frame.size.height, view.frame.size.width, view.frame.size.height - topView.frame.size.height)
            view.addSubview(blurEffectView)
            view.addGestureRecognizer(tapCloseDropDownMenu)
            
        } else {
            dropDownAddressButton?.hideDropDown(dropDownAddressSender as UIButton)
            dropDownAddressButton = nil
            blurEffectView.removeFromSuperview()
            view.removeGestureRecognizer(tapCloseDropDownMenu)
        }
    }
    
    func hidDropDownMenu(){
        dropDownAddressButton?.hideDropDown(dropDownAddressSender as UIButton)
        dropDownAddressButton = nil
        blurEffectView.removeFromSuperview()
        view.removeGestureRecognizer(tapCloseDropDownMenu)
    }
    
    func doSearch(){
        initSearchTableView()
        
    }
}

extension MainMenuViewController {

    func dropDownMenuClicked(sender: DropDownButton) {
        blurEffectView.removeFromSuperview()
        switch sender.choosedString! {
        case "New Location":
            
            doSearch()
            //Account.sharedManager.location(Account.requestMethod.PUT, )
        default:
            print(sender.choosedString)
            doSearch()
        }
        print("you choose:\(sender.choosedString)")
        dropDownAddressButton = nil
    }

    func dropDownMenuDelete(sender: DropDownButton, string:String) {
        Account.sharedManager.location(Account.requestMethod.DELETE, location: string)
        dropDownAddressButton!.dropDownTableView?.frame = CGRectMake(0, 0, (dropDownAddressSender.superview!.frame.size.width),cellHeight * CGFloat((Account.sharedManager.location!.count)))
        dropDownAddressSender.setTitle("Choose Location  ▾", forState: .Normal)
    }
}

extension MainMenuViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        //filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchTableView?.removeFromSuperview()
        blurEffectForTable.removeFromSuperview()
        //blurEffectForTable.removeGestureRecognizer(tapCloseSearchBar)
        searchController.searchBar.removeFromSuperview()
        
        //self.definesPresentationContext = true
        //searchController.dismissViewControllerAnimated(true, completion: nil)
        //searchController.active = false
        
    }
    
    func searchBarCancelButtonClicked() {
        searchTableView?.removeFromSuperview()
        blurEffectForTable.removeFromSuperview()
        //blurEffectForTable.removeGestureRecognizer(tapCloseSearchBar)
        

        dismissViewControllerAnimated(true, completion: nil)
        
    }
}

extension MainMenuViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        let searchBar = searchController.searchBar
//        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
//        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

extension MainMenuViewController:UITableViewDelegate, UITableViewDataSource { //for search tableView
    
    
    func initSearchTableView(){
        searchTableView = UITableView(frame: CGRectMake(0, topView.frame.size.height, view.frame.size.width, 2*cellHeight*1.5))
        blurEffectForTable.frame = CGRectMake(view.bounds.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
        blurEffectForTable.addGestureRecognizer(tapCloseSearchBar)
        self.searchTableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "searchCell")//must
        
       
        presentViewController(searchController, animated: true, completion: {
            self.view.addSubview(self.blurEffectForTable)
            self.view.addSubview(self.searchTableView!)
        })
        searchTableView!.delegate = self
        searchTableView!.dataSource = self
                //presentedViewController(searchController.searchBar)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight*1.5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView .dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 0.5)
        
        let textLabel = UILabel(frame: CGRectMake(40, 0, 100, 40))
        textLabel.text = "search"
        textLabel.font = UIFont(name: "HelveticaNeue-Light", size: 13)
        textLabel.textColor = UIColor.whiteColor()
        textLabel.textAlignment = .Left
        
        let imageView = UIImageView(frame: CGRectMake(5,10, 20, 20))
        imageView.image = UIImage(named: "addGreen.png")
        cell.contentView.addSubview(imageView)
        cell.contentView.addSubview(textLabel)
        
        return cell
    }
}