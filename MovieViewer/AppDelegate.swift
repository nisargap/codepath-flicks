//
//  AppDelegate.swift
//  MovieViewer
//
//  Created by Nisarga Patel on 2/1/16.
//  Copyright © 2016 Nisarga Patel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func sizeMyIcon(iconName : String) -> UIImage{
        
        let npImage = UIImage(named: iconName)
        let resizedImage = UIImage(CGImage: npImage!.CGImage!, scale: 1.75, orientation: (npImage?.imageOrientation)!)
        return resizedImage
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nowplayingNav = storyboard.instantiateViewControllerWithIdentifier("mainNav") as! UINavigationController
        let nowplayingView = nowplayingNav.topViewController as! MoviesViewController
        nowplayingView.endpoint = "now_playing"
        nowplayingNav.tabBarItem.title = "Now Playing"
        
        nowplayingNav.tabBarItem.image = sizeMyIcon("now_playing")
        
        let trplayingNav = storyboard.instantiateViewControllerWithIdentifier("mainNav") as! UINavigationController
        let trplayingView = trplayingNav.topViewController as! MoviesViewController
        trplayingView.endpoint = "top_rated"
        trplayingNav.tabBarItem.title = "Top Rated"
        trplayingNav.tabBarItem.image = sizeMyIcon("top_rated")
        
        let upplayingNav = storyboard.instantiateViewControllerWithIdentifier("mainNav") as! UINavigationController
        let upplayingView = upplayingNav.topViewController as! MoviesViewController
        upplayingView.endpoint = "popular"
        upplayingNav.tabBarItem.title = "Popular"
        upplayingNav.tabBarItem.image = sizeMyIcon("popular")
        
        let tabControl = UITabBarController()
        tabControl.viewControllers = [nowplayingNav, trplayingNav, upplayingNav]
        tabControl.tabBar.barTintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        tabControl.tabBar.tintColor = UIColor(red: 1.0, green: 224/255, blue: 25/255, alpha: 1.0)

        
        window?.rootViewController = tabControl
        window?.makeKeyAndVisible()
        
        
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


}

