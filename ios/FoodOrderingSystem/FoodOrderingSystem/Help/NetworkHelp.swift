//
//  networkHelp.swift
//  FoodOrderingSystem
//
//  Created by MoonSlides on 16/1/17.
//  Copyright © 2016年 李龑. All rights reserved.
//

import UIKit

class NetworkHelp: NSObject {
    
    func sendPostRequest(action: String, params:[String : AnyObject]){
        let url:NSURL = NSURL(string: "http://localhost:8080/api/\(action)")!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        
//        let params:[String : AnyObject] = [
//            "email" : email,
//            "password" : password
//        ]
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions(rawValue: 0))
            print(NSString(data: request.HTTPBody!, encoding: NSUTF8StringEncoding))
        }
        catch {
            print(error)
        }
        
        let task = session.dataTaskWithRequest(request, completionHandler:{
            data, response, error -> Void in
            if error != nil {
                print(error)
            }
            else{
                //print("request success")
                //print(response!)
                let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print(dataString!)
            }
        })
        
        
        task.resume()
    }
    
}
