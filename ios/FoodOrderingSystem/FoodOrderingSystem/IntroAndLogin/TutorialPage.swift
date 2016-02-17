//
//  PageContentViewController.swift
//  FoodOrderingSystem
//
//  Created by MoonSlides on 16/1/16.
//  Copyright © 2016年 李龑. All rights reserved.
//

import UIKit

class TutorialPage: UIViewController {


    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var introTextView: UITextView!
    
    @IBOutlet weak var btnLogin2: UIButton!
    var pageIndex:UInt = 0
    var imageFile:String = ""
    var textTitle:String = ""
    var textContents: String = ""
    let labelStringForBtn = "Log in with your account and Enjoy"
    let labelStringColor = "Log in"
    let labelStringBlack = " with your account and Enjoy"
    //var labelStringForLogin = NSMutableAttributedString.init(string: "Already have an account? Log in")
    
//    var range = (labelStringForBtn as NSString).rangeOfString(labelStringForLogin)
//    var attributedString = NSMutableAttributedString(string: labelStringForBtn)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageTitle.text = textTitle
        self.imageView.image = UIImage(named: imageFile)
        self.introTextView.text = textContents
        
        setAttributedString()
        
        btnLogin.hidden = true
        btnLogin2.hidden = true
        
        if pageIndex == 0 {
            btnLogin.hidden = false
            btnLogin2.hidden = true
        }
        if pageIndex == 2 {
            btnLogin2.hidden = false
            btnLogin.hidden = true
        }
        self.prefersStatusBarHidden()
        //performSegueWithIdentifier("login", sender: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func login(sender: AnyObject) {
    }

    func setAttributedString() {
        let range = (labelStringForBtn as NSString).rangeOfString(labelStringColor)
        let rangefull = (labelStringForBtn as NSString).rangeOfString(labelStringForBtn)
        let rangeBlack = (labelStringForBtn as NSString).rangeOfString(labelStringBlack)
        
        let attributedString = NSMutableAttributedString(string: labelStringForBtn)
        
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 69/255, green: 83/255, blue: 153/255, alpha: 1), range: range)
        
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 95/255, green: 94/255, blue: 95/255, alpha: 1), range: rangeBlack)
        
        let attributedStringClicked = NSMutableAttributedString(string: labelStringForBtn)
        
        
        attributedStringClicked.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(white: 0.5, alpha: 0.5), range: rangefull)
        attributedStringClicked.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 69/255, green: 83/255, blue: 153/255, alpha: 0.5), range: range)
        btnLogin.setAttributedTitle(attributedString, forState: .Normal)
        btnLogin.setAttributedTitle(attributedStringClicked, forState: .Highlighted)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
