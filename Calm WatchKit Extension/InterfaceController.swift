//
//  InterfaceController.swift
//  Calm WatchKit Extension
//
//  Created by Johannes Schickling on 5/30/15.
//  Copyright (c) 2015 Optonaut. All rights reserved.
//

import WatchKit
import Foundation
import SwiftyJSON
import Darwin


class InterfaceController: WKInterfaceController {
    
    var timer: NSTimer?
    
    @IBOutlet weak var exerciseImage: WKInterfaceImage!
    @IBOutlet weak var stressLevelImage: WKInterfaceImage!

    let screenSize = WKInterfaceDevice.currentDevice().screenBounds
    var scaling:Double = 0.1
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        stressLevelImage.setImageNamed("level")
        stressLevelImage.startAnimatingWithImagesInRange(
            NSRange(location: 0, length: 150),
            duration: 6,
            repeatCount: 0)

        exerciseImage.setImageNamed("exercise")
        exerciseImage.startAnimatingWithImagesInRange(
            NSRange(location: 0, length: 610),
            duration: 24.4,
            repeatCount: 0)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("fetchData"), userInfo: nil, repeats: true)
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        
        timer?.invalidate()
    }
    
    func fetchData() {
        let url = NSURL(string: "http://\(Constants.SERVER_IP)/stress")

        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let json = JSON(data: data)
            let heartrate = json["heartrate"].doubleValue * 60
            var stress = json["stress"].doubleValue
            let heartrateString: String = String(format:"♡ %1.f", heartrate)

            stress = stress / 1.5 //Scale stress so full stress does not fill the screen. 

            //Constrain stress to some meaningful values. 
            if stress > 1 {
                stress = 1
            } else if stress < 0.1 {
                stress = 0.1
            }
            
            stress = log(stress * M_E + 1)

            scaling = (stress + scaling) / 2 //Lowpass filter

            let stressLevelWidth: Double = 312 / 2
            let stressLevelHeigth: Double = 280 / 2
            self.stressLevelImage.setWidth(CGFloat(stressLevelWidth * scaling))
            self.stressLevelImage.setHeight(CGFloat(stressLevelHeigth * scaling))
            self.setTitle(heartrateString)
        }

        task.resume()
    }
    
}
