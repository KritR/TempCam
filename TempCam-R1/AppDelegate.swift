//
//  AppDelegate.swift
//  TempCam-R1
//
//  Created by Krithik Rao on 8/30/17.
//  Copyright © 2017 Krithik Rao. All rights reserved.
//

import UIKit
import Photos

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().barTintColor = UIColor(red: 234.0/255.0, green: 46.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes =
            [NSForegroundColorAttributeName : UIColor.white, (NSFontAttributeName as NSObject) as! String : UIFont(name: "Noteworthy-Bold", size: 20) as AnyObject]
        UIToolbar.appearance().barTintColor = UIColor(red: 234.0/255.0, green: 46.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        UIToolbar.appearance().tintColor = UIColor.white
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 65.0, repeats: true, block: timerDidFire)
        } else {
            Timer.scheduledTimer(timeInterval: 65.0, target: self, selector: #selector(AppDelegate.timerDidFire(_:)), userInfo: nil, repeats: true)
        }

        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func timerDidFire(_ timer: Timer!){
        
        var imageKey: [AnyObject] = []
        
        if(UserDefaults.standard.object(forKey: "photoDict") != nil){
            var dictionary = UserDefaults.standard.object(forKey: "photoDict") as! Dictionary<String, NSDate>
            for (key, value) in dictionary{
                if(value.timeIntervalSinceNow<=0){
                    imageKey.append(key as AnyObject)
                    dictionary.removeValue(forKey: key)
                }
                
            }
            let image = PHAsset.fetchAssets(withLocalIdentifiers: imageKey as! [String], options: nil)
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.deleteAssets(image)
            }, completionHandler: {
                success, error in
                NSLog("Finished deleting Asset")
            })
            
            UserDefaults.standard.removeObject(forKey: "photoDict")
            UserDefaults.standard.set(dictionary as Dictionary<String,NSDate>, forKey: "photoDict")

        }
    }


}

