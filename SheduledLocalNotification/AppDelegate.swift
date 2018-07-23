//
//  AppDelegate.swift
//  Notifications
//
//  Created by Matthew Newill on 10/05/2017.
//  Copyright © 2017 Mobient. All rights reserved.
//

import UIKit
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
  

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UserDefaults.standard.setUserID(value: 0)
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        let centre = UNUserNotificationCenter.current()
        centre.requestAuthorization(options: [.alert, .sound ,.badge]) { (granted, error) in
            // Enable or disable features based on authorization
            UNUserNotificationCenter.current().delegate = self
        }
        return true
    }
    func sendNotificationIn5Seconds() {
            let centre = UNUserNotificationCenter.current()
            centre.getNotificationSettings { (settings) in
                if settings.authorizationStatus != UNAuthorizationStatus.authorized {
                    print("Not Authorised")
                } else {
                    print("Authorised")
                    let content = UNMutableNotificationContent()
                    content.title = NSString.localizedUserNotificationString(forKey: "This is the title", arguments: nil)
                    content.body = NSString.localizedUserNotificationString(forKey: "The message body goes here.", arguments: nil)
                    UserDefaults.standard.setUserID(value: UserDefaults.standard.getUserID()!+1)
                    content.badge = (UserDefaults.standard.getUserID()! as NSNumber)
                    content.categoryIdentifier = "Category"
                    content.userInfo = ["SendInfo": "info"]
                    
                    
                    let now = Date()
//                    let snoozeMinute = 1
//                    let snoozeTime =  (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: snoozeMinute, to: now, options:.matchStrictly)!
//                    let newDate = Date(timeInterval: 1, since: snoozeTime)

                    
                    // Schedule the notification.
                    
                    //triggerWeekly
                    let triggerWeekly = Calendar.current.dateComponents([.weekday, .hour, .minute, .second], from: now)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
                    //triggerWeekly

//                    //triggerDaily
//                    let triggerDaily = Calendar.current.dateComponents([.hour, .minute, .second], from: now)
//                    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
//                    //triggerDaily
                    
                    
//                    // Deliver the notification in five seconds.
//                    content.sound = UNNotificationSound.default()//UNNotificationSound(named: "bell.mp3")
//                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//                    // Deliver the notification in five seconds.
                    
                    let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger)
                    let center = UNUserNotificationCenter.current()
                    
                    let rememberMeLater = UNNotificationAction.init(identifier: "Remember me later", title: "Remember me later", options: UNNotificationActionOptions.destructive)
                    let ok = UNNotificationAction.init(identifier: "Ok", title: "Ok", options: UNNotificationActionOptions.foreground)
                   
                    let categories = UNNotificationCategory.init(identifier: "Category", actions: [rememberMeLater,ok], intentIdentifiers: [], options: [])
                    centre.setNotificationCategories([categories])
                    
                    center.add(request, withCompletionHandler: nil)
                }
            }
        }
    
    
     func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            
            print("Test: \(response.notification.request.content.userInfo)")
        
            switch response.actionIdentifier {
            case "Remember me later":
                print("Remember me later")
                
                completionHandler()
                sendNotificationIn5Seconds()
                
             case "Ok":
                print("Ok")
                
                completionHandler()

            default:
                completionHandler()
            }
            completionHandler()
        }
    
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            print("Test Foreground: \(notification.request.identifier)")
         
            completionHandler([.alert, .sound,.badge])
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
}



enum UserDefaultsKeys : String
{
  case userID
}
extension UserDefaults
{
    func setUserID(value: Int){
        set(value, forKey: UserDefaultsKeys.userID.rawValue)
        synchronize()
    }
    //MARK: Retrieve User Data
    func getUserID() -> Int?{
        return integer(forKey: UserDefaultsKeys.userID.rawValue)
    }
}

