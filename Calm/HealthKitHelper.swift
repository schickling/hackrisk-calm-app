//
//  HealthKitHelper.swift
//
//
//  Created by Johannes Schickling on 5/30/15.
//
//

import Foundation
import HealthKit
import CoreMotion

class HealthKit : NSObject
{
    let motion =  CMMotionManager()
    let storage = HKHealthStore()
    var authorized = false
    
    override init()
    {
        super.init()
        
        checkAuthorization()
    }
    
    func checkAuthorization() -> Void
    {
        
        // Do we have access to HealthKit on this device?
        if HKHealthStore.isHealthDataAvailable() {
            // We have to request each data type explicitly
            let steps = Set([
                HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate),
//                HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyTemperature),
//                HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBloodPressureSystolic),
//                HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierRespiratoryRate)
                ])
            
            // Now we can request authorization for step count data
            storage.requestAuthorizationToShareTypes(nil, readTypes: steps) { (success, error) -> Void in
                self.authorized = success
            }
        } else {
            authorized = false
        }
    }
    
    func fetchAll()
    {
        if self.authorized {
            fetchData(HKQuantityTypeIdentifierHeartRate)
        }
        //        fetchData(HKQuantityTypeIdentifierBodyTemperature)
        //        fetchData(HKQuantityTypeIdentifierBloodPressureSystolic)
        //        fetchData(HKQuantityTypeIdentifierRespiratoryRate)
    }
    
    func fetchData(identifier: String)
    {
        let type = HKSampleType.quantityTypeForIdentifier(identifier)
        
        let today = NSDate()
        let lastSecond = NSCalendar.currentCalendar().dateByAddingUnit(
            .CalendarUnitSecond,
            value: -10,
            toDate: today,
            options: NSCalendarOptions(0))
        let predicate = HKQuery.predicateForSamplesWithStartDate(lastSecond, endDate: today, options: .None)
        
        let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: 0, sortDescriptors: nil) {
            query, results, error in
            
            if error != nil {
                println("Error fetching " + identifier)
                println(error.localizedDescription)
                abort()
            }
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "hh:mm:ss"
            
            for result in results {
                
                print(identifier)
                print(", ")
                print(formatter.stringFromDate(result.startDate))
                print(", ")
                println(result.quantity)
                
                let unit = HKUnit.countUnit().unitDividedByUnit(HKUnit.secondUnit())
                let quantity = result.quantity!.doubleValueForUnit(unit)
                let params = ["s": quantity, "t": 0] as Dictionary<String, Double>
                let url = NSURL(string: "http://\(Constants.SERVER_IP)/heart")
                
                self.executePostRequest(url!, params: params);
            }
        }
        
        storage.executeQuery(query)
    }
    
    func executePostRequest(url: NSURL, params: Dictionary<String, Double>) {
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: nil)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: nil)
        
        task.resume()
    }
    
    func uploadAccData(vec: CMAcceleration) {
        let params = ["x": vec.x, "y": vec.y, "z": vec.z, "t": 0] as Dictionary<String, Double>
        let url = NSURL(string: "http://\(Constants.SERVER_IP)/acc")
        self.executePostRequest(url!, params: params);
    }
    
    func startPollData() {
        var timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("fetchAll"), userInfo: nil, repeats: true)
        
        
        motion.accelerometerUpdateInterval = 0.25
        if motion.accelerometerAvailable == true {
            motion.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler:{
                data, error in
                if error != nil {
                    println("Error fetching accellerometer data")
                    println(error.localizedDescription)
                    abort()
                }
                self.uploadAccData(data.acceleration)
            })
        }
        
    }
    
}