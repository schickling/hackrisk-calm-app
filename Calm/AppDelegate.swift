//
//  AppDelegate.swift
//  Calm
//
//  Created by Johannes Schickling on 5/31/15.
//  Copyright (c) 2015 Optonaut. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let userHasOnboardedKey = "user_has_onboarded"


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()
        
        application.statusBarStyle = .LightContent
        
        // Determine if the user has completed onboarding yet or not
        var userHasOnboardedAlready = NSUserDefaults.standardUserDefaults().boolForKey(userHasOnboardedKey);
        
        // If the user has already onboarded, setup the normal root view controller for the application
        // without animation like you normally would if you weren't doing any onboarding
        if userHasOnboardedAlready {
            self.setupNormalRootVC(false);
        }
            
            // Otherwise the user hasn't onboarded yet, so set the root view controller for the application to the
            // onboarding view controller generated and returned by this method.
        else {
            self.window!.rootViewController = self.generateOnboardingViewController()
        }
        
        self.window!.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func generateOnboardingViewController() -> OnboardingViewController {
        
        let first: OnboardingContentViewController = OnboardingContentViewController(title: "Calm helps you to manage your stress.", body: "", image: UIImage(named: "step1"), buttonText: "") {
        }
        
        let second: OnboardingContentViewController = OnboardingContentViewController(title: "Calm does this by monitoring your heart-rate.", body: "", image: UIImage(named: "step2"), buttonText: "") {
        }
        
        let third: OnboardingContentViewController = OnboardingContentViewController(title: "Calm breathes with you, until you're relaxed.", body: "", image: UIImage(named: "step3"), buttonText: "") {
        }
        
        let fourth: OnboardingContentViewController = OnboardingContentViewController(title: "Your current heartrate is 75 BPM, so everything is okay.", body: "From now on, you don't have to worry about your stress level anymore.", image: UIImage(named: "step4"), buttonText: "Get started") {
            self.handleOnboardingCompletion()
        }
        
        let contents = [first, second, third, fourth]
        
        for c in contents {
            c.iconSize = UIScreen.mainScreen().bounds.width
            c.topPadding = 0
            c.underIconPadding = 50
            c.titleFontSize = 24
        }
        
        fourth.iconSize = UIScreen.mainScreen().bounds.width * 0.64
        fourth.bodyFontSize = 24
        fourth.underIconPadding = 20
        fourth.topPadding = 23
//        fourth.buttonTextColor = UIColor(red: 77, green: 159, blue: 93, alpha: 1)
        
        
        let onboardingVC: OnboardingViewController = OnboardingViewController(backgroundImage: UIImage(named: "onboarding"), contents: contents)
        
        onboardingVC.shouldMaskBackground = false
        
        return onboardingVC
    }
    
    func handleOnboardingCompletion() {
        // Now that we are done onboarding, we can set in our NSUserDefaults that we've onboarded now, so in the
        // future when we launch the application we won't see the onboarding again.
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: userHasOnboardedKey)
        
        // Setup the normal root view controller of the application, and set that we want to do it animated so that
        // the transition looks nice from onboarding to normal app.
        setupNormalRootVC(true)
    }
    
    func setupNormalRootVC(animated : Bool) {
        // Here I'm just creating a generic view controller to represent the root of my application.
        var mainVC = CalmViewController()
        mainVC.title = "Calm"
        
        // If we want to animate it, animate the transition - in this case we're fading, but you can do it
        // however you want.
        if animated {
            UIView.transitionWithView(self.window!, duration: 0.5, options:.TransitionCrossDissolve, animations: { () -> Void in
                self.window!.rootViewController = mainVC
                }, completion:nil)
        }
            
            // Otherwise we just want to set the root view controller normally.
        else {
            self.window?.rootViewController = mainVC;
        }
    }


}

