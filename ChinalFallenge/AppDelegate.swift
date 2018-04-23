//
//  AppDelegate.swift
//  ChinalFallenge
//
//  Created by Simone Fiorentino on 13/04/2018.
//  Copyright © 2018 Simone Fiorentino. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        let shortcut2 = UIMutableApplicationShortcutItem(type: "MyItems", localizedTitle: "My Items", localizedSubtitle: "", icon: UIApplicationShortcutIcon(type: .home), userInfo: nil)
        application.shortcutItems = [shortcut2]
        // application.shortcutItems?.append(shortcut2) same way to create a new quick button.
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        completionHandler(false)
        
        if let rootTabBar = UIApplication.shared.keyWindow?.rootViewController as? MyTabBarController {
            if (shortcutItem.type == "Scan") {
                DispatchQueue.main.async {
                    rootTabBar.selectedIndex = 0
                }
            } else if (shortcutItem.type == "MyItems") {
                DispatchQueue.main.async {
                    rootTabBar.selectedIndex = 2
                }
            }
        }
    }
    
}








