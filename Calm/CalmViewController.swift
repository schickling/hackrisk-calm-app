//
//  ViewController.swift
//  StressWatch
//
//  Created by Johannes Schickling on 5/29/15.
//  Copyright (c) 2015 Johannes Schickling. All rights reserved.
//


import UIKit
import SwiftyJSON

class CalmViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        HealthKit().startPollData()
        
        // stress poll background
//        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("stressFetch"), userInfo: nil, repeats: true)
        
        
//        var localNotification: UILocalNotification = UILocalNotification()
//        localNotification.alertAction = "Time to breath?"
//        localNotification.alertBody = "Time to breath?"
//        localNotification.fireDate = NSDate(timeIntervalSinceNow: 10)
//        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    func stressFetch() {
//        let url = NSURL(string: "http://\(Constants.SERVER_IP)/stress")
//        
//        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
//            let json = JSON(data: data)
//            let heartrate = json["heartrate"].doubleValue * 60
//            var stress = json["stress"].doubleValue
//            
//            if stress > 0.8 {
//                var localNotification: UILocalNotification = UILocalNotification()
//                localNotification.alertAction = "Time to breath?"
//                localNotification.alertBody = "Time to breath?"
//                localNotification.fireDate = NSDate(timeIntervalSinceNow: 1)
//                UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
//            }
//        }
//        
//        task.resume()
//    }
//    
}

