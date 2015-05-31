//
//  ViewController.swift
//  StressWatch
//
//  Created by Johannes Schickling on 5/29/15.
//  Copyright (c) 2015 Johannes Schickling. All rights reserved.
//


import UIKit

class CalmViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        HealthKit().startPollData()
        
        var localNotification: UILocalNotification = UILocalNotification()
        localNotification.alertAction = "Testing notifications on iOS8"
        localNotification.alertBody = "Woww it works!!"
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 10)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

