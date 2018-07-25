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
    
    
    
    func getDailyTrigger(datetime:Date) -> UNCalendarNotificationTrigger
    {
        //triggerDaily
        let triggerDaily = Calendar.current.dateComponents([.hour, .minute, .second], from: datetime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        return trigger
        //triggerDaily
    }
    func getWeeklyTriggre(datetime:Date) -> UNCalendarNotificationTrigger {
        
        //triggerWeekly
        let triggerWeekly = Calendar.current.dateComponents([.weekday, .hour, .minute, .second], from: datetime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
        return trigger
        //triggerWeekly
    }
    func getInstantTriggre() -> UNTimeIntervalNotificationTrigger {
        
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
      return trigger
    }
    func setTriggerToParticularDate(dateTime:Date) -> UNCalendarNotificationTrigger
    {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: dateTime)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        return trigger
    }
    func getOneMiniuteSnoozeTrigger(snoozeMinute:Int) -> UNCalendarNotificationTrigger {
        let now = Date()
        let snoozeMinute = snoozeMinute
        let calendar = Calendar(identifier: .gregorian)
        let snoozeTime =  (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: snoozeMinute, to: now, options:.matchStrictly)!
        let newDate = Date(timeInterval: 1, since: snoozeTime)
        let components = calendar.dateComponents(in: .current, from: newDate)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        return trigger
    }
    
    func sendNotificationIn5Seconds()
    {
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
                    content.sound = UNNotificationSound.default()//UNNotificationSound(named: "bell.mp3")
         
                 
                    //let trigger = self.getOneMiniuteSnoozeTrigger(snoozeMinute:1)
                    let trigger = self.getInstantTriggre()
                    //let trigger = self.getDailyTrigger(datetime: Date())
                    //let trigger = self.getWeeklyTriggre(datetime: Date())
                    

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
    
    
    
    func sheduleNotification(date1:Date)
    {
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
                content.sound = UNNotificationSound.default()//UNNotificationSound(named: "bell.mp3")
                let trigger = self.setTriggerToParticularDate(dateTime: date1)
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








/*

//
//  AppDelegate.swift
//  Cipla
//
//  Created by Hitendra Bhoir on 27/06/18.
//  Copyright © 2018 Fortune4 Technologies. All rights reserved.
//
import UIKit
import CoreData
import IQKeyboardManagerSwift
import UserNotifications
import FBSDKCoreKit
import FBSDKLoginKit
import Google
import GoogleSignIn
import TwitterKit
import TwitterCore
import CoreLocation
import GoogleMaps
import RealmSwift
import GooglePlaces
import UserNotifications
import AudioToolbox
import AVFoundation
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    var locationManager = CLLocationManager()
    //var notificationCenter: UNUserNotificationCenter!
    var centre = UNUserNotificationCenter.current()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        GMSPlacesClient.provideAPIKey("AIzaSyAC2MLjxYsAWGJnR3tNmovGFhOA4ymGAUI")
        
        FbAndGoogleSetUP(application,launchOptions: launchOptions)
        
        self.setStausBarAndNavigationBarColor()
        
        self.setUpIQKeyboradManager()
        
        self.getCurrentLocaton()
        
        self.googleMap()
        
        self.setUP()
        
        DBManager.shared.realmDataBaseSetup()
        self.setRootVC()
        self.locationMethods(launchOptions: launchOptions)
        _ = ReminderManager()
        return true
    }
    
    func googleMap()
    {
        GMSServices.provideAPIKey("AIzaSyCLx3Wh25rVTz5ZYrYABIlZ9CJYPmtryyw")
    }
    func FbAndGoogleSetUP(_ application: UIApplication,launchOptions:[UIApplicationLaunchOptionsKey: Any]?) {
        
        
        TWTRTwitter.sharedInstance().start(withConsumerKey:"onoMRtjcihstBaY9lFgMgRmSu", consumerSecret:"h6kwf88idl7H95OQuBLAbd56WCkLY6LBekbl2zDeQlTzYx2lzw")
        GIDSignIn.sharedInstance().clientID = "816681505044-8li5brp2nophsh2jna6vs5fi3pven9md.apps.googleusercontent.com"
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func setRootVC()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "SplashScreenVC") as! SplashScreenVC
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        self.window?.rootViewController = nvc
        self.window?.makeKeyAndVisible()
    }
    func logout()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        self.window?.rootViewController = nvc
        self.window?.makeKeyAndVisible()
    }
    
    func setUpIQKeyboradManager()
    {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
    }
    
    func setStausBarAndNavigationBarColor()
    {
        
        //        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        //        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
        //            statusBar.backgroundColor = Constant.AppColor.navigationColor
        //        }
        UINavigationBar.appearance().barTintColor = colorButton
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        let myAttribute = [ NSAttributedStringKey.font: UIFont(name: "JosefinSans-Bold", size: 22.0)! , NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = myAttribute
        
    }
    func locationMethods(launchOptions:[UIApplicationLaunchOptionsKey: Any]?)  {
        self.locationManager = CLLocationManager()
        //        for monitor in locationManager.monitoredRegions
        //        {
        //            locationManager.stopMonitoring(for: monitor)
        //        }
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        self.locationManager.distanceFilter = 1
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // get the singleton object
        self.centre = UNUserNotificationCenter.current()
        
        // register as it's delegate
        centre.delegate = self
        
        // define what do you need permission to use
        let options: UNAuthorizationOptions = [.alert, .sound]
        
        // request permission
        centre.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                print("Permission not granted")
            }
        }
        
        if launchOptions?[UIApplicationLaunchOptionsKey.location] != nil {
            print("I woke up thanks to geofencing")
        }
        
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Cipla")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
extension AppDelegate: CLLocationManagerDelegate {
    
    func handleEvent(forRegion region: CLRegion!,dic: Dictionary<String,Any>!,enterIn:String) {
        
        // customize your notification content
        let content = UNMutableNotificationContent()
        content.title = enterIn
        content.body =  dic["location"] as! String
        content.subtitle = dic["trigger"] as! String
        content.sound = UNNotificationSound.default()
        // when the notification will be triggered
        let timeInSeconds: TimeInterval = 1
        // the actual trigger object
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timeInSeconds,
            repeats: false
        )
        
        // notification unique identifier, for this example, same as the region to avoid duplicate notifications
        let identifier = region.identifier
        
        // the notification request object
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        // trying to add the notification request to notification center
        centre.add(request, withCompletionHandler: { (error) in
            if error != nil {
                print("Error adding notification with identifier: \(identifier)")
            }
        })
    }
    
    func getCurrentLocaton()
    {
        
        locationManager.requestWhenInUseAuthorization();
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        else{
            print("Location service disabled");
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        Constant.shared.setCurrentLat(lat: "\(locValue.latitude)")
        Constant.shared.setCurrentLong(long: "\(locValue.longitude)")
        
    }
    
    // called when user Exits a monitored region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            // Do what you want if this information
            
            print("didExitRegion")
            let str = region.identifier
            
            if let dict = self.convertToDictionary(text: str)
            {
                self.handleEvent(forRegion: region, dic: dict, enterIn: "Exit from")
            }
            
        }
    }
    // called when user Enters a monitored region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            // Do what you want if this information
            print("didEnterRegion")
            
            let str = region.identifier
            
            if let dict = self.convertToDictionary(text: str)
            {
                self.handleEvent(forRegion: region, dic: dict, enterIn: "Enter in")
            }
            
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}

extension AppDelegate {
    
    
    func setUP()  {
        
        self.centre.requestAuthorization(options: [.alert, .sound ,.badge]) { (granted, error) in
            UNUserNotificationCenter.current().delegate = self
        }
        
        
        let rememberMeLater = UNNotificationAction.init(identifier: "Remind me later", title: "Remind me later", options: UNNotificationActionOptions.destructive)
        
        let yes = UNNotificationAction.init(identifier: "Yes", title: "Yes", options: UNNotificationActionOptions.foreground)
        
        let no = UNNotificationAction.init(identifier: "No", title: "No", options: UNNotificationActionOptions.foreground)
        
        let categories = UNNotificationCategory.init(identifier: "Categeory", actions: [yes,no,rememberMeLater], intentIdentifiers: [], options: [])
        
        
        
        let categories1 = UNNotificationCategory.init(identifier: "Categeory1", actions: [rememberMeLater], intentIdentifiers: [], options: [])
        
        self.centre.setNotificationCategories([categories,categories1])
        
        
        
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func getDailyTrigger(datetime:Date) -> UNCalendarNotificationTrigger
    {
        //triggerDaily
        let triggerDaily = Calendar.current.dateComponents([.hour, .minute, .second], from: datetime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        return trigger
        //triggerDaily
    }
    
    func getInstantTriggre(weekdaySet:[Int]) -> [UNTimeIntervalNotificationTrigger] {
        
        
        let intervel = 86400.0 * Double(weekdaySet[0])
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: intervel, repeats: true)
        return [trigger]
    }
    
    func getWeeklyTriggre(datetime:Date,weekdaySet:[Int]) -> [UNCalendarNotificationTrigger] {
        
        //triggerWeekly
        
        var triggerArray = [UNCalendarNotificationTrigger]()
        for i in weekdaySet
        {
            
            let hour = Calendar.current.component(.hour, from: datetime)
            let minute = Calendar.current.component(.minute, from: datetime)
            var dateInfo = DateComponents()
            dateInfo.hour = hour
            dateInfo.minute = minute
            dateInfo.weekday = i
            dateInfo.timeZone = .current
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
            triggerArray.append(trigger)
        }
        return triggerArray
        
        //        let triggerWeekly = Calendar.current.dateComponents([.weekday, .hour, .minute, .second], from: datetime)
        
        //let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
        
        //triggerWeekly
    }
    func getInstantTriggre() -> UNTimeIntervalNotificationTrigger {
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        return trigger
    }
    
    func setTriggerToParticularDate(dateTime:Date) -> UNCalendarNotificationTrigger
    {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: dateTime)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        return trigger
    }
    func getOneMiniuteSnoozeTrigger(snoozeMinute:Int) -> UNCalendarNotificationTrigger {
        let now = Date()
        let snoozeMinute = snoozeMinute
        let calendar = Calendar(identifier: .gregorian)
        let snoozeTime =  (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: snoozeMinute, to: now, options:.matchStrictly)!
        let newDate = Date(timeInterval: 1, since: snoozeTime)
        let components = calendar.dateComponents(in: .current, from: newDate)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        return trigger
    }
    func sheduleNotificationForDrAppoinment(date1:Date,info:Dictionary<String,String>,triggerNew:UNCalendarNotificationTrigger)
    {
        
        self.centre.getNotificationSettings { (settings) in
            if settings.authorizationStatus != UNAuthorizationStatus.authorized {
                print("Not Authorised")
            } else {
                print("Authorised")
                let content = UNMutableNotificationContent()
                content.title = info["title"] ?? ""
                content.body = info["body"] ?? ""
                UserDefaults.standard.setNotificationCount(value: UserDefaults.standard.getNotificationCount()!+1)
                //content.badge = (UserDefaults.standard.getNotificationCount()! as NSNumber)
                content.categoryIdentifier = "Categeory" //info["appointmentId"]!
                content.userInfo = info
                content.sound = UNNotificationSound.default()//UNNotificationSound(named: "bell.mp3")
                print(date1)
                let trigger = triggerNew //self.setTriggerToParticularDate(dateTime: date1)
                let request = UNNotificationRequest(identifier: info["appointmentId"] ?? "EMPTY", content: content, trigger: trigger)
                
                
                self.centre.add(request, withCompletionHandler: nil)
            }
        }
    }
    
    func sheduleNotificationForInhalerDose(date1:Date,info:Dictionary<String,String>,triggerNew:UNCalendarNotificationTrigger)
    {
        
        self.centre.getNotificationSettings { (settings) in
            if settings.authorizationStatus != UNAuthorizationStatus.authorized {
                print("Not Authorised")
            } else {
                print("Authorised")
                let content = UNMutableNotificationContent()
                content.title = info["title"] ?? ""
                content.body = info["body"] ?? ""
                UserDefaults.standard.setNotificationCount(value: UserDefaults.standard.getNotificationCount()!+1)
                //content.badge = (UserDefaults.standard.getNotificationCount()! as NSNumber)
                content.categoryIdentifier = "Categeory"// info["inhalerDoseId"]!
                content.userInfo = info
                content.sound = UNNotificationSound.default()//UNNotificationSound(named: "bell.mp3")
                print(date1)
                let trigger = triggerNew //self.setTriggerToParticularDate(dateTime: date1)
                let request = UNNotificationRequest(identifier: info["inhalerDoseId"] ?? "EMPTY", content: content, trigger: trigger)
                
                print("Normal \(request)")
                self.centre.add(request, withCompletionHandler: nil)
            }
        }
    }
    func sheduleNotificationForInhalerDoseSnooze(date1:Date,info:Dictionary<String,String>,triggerNew:UNCalendarNotificationTrigger)
    {
        
        self.centre.getNotificationSettings { (settings) in
            if settings.authorizationStatus != UNAuthorizationStatus.authorized {
                print("Not Authorised")
            } else {
                print("Authorised")
                let content = UNMutableNotificationContent()
                content.title = info["title"] ?? ""
                content.body = info["body"] ?? ""
                UserDefaults.standard.setNotificationCount(value: UserDefaults.standard.getNotificationCount()!+1)
                //content.badge = (UserDefaults.standard.getNotificationCount()! as NSNumber)
                content.categoryIdentifier = "Categeory"// info["inhalerDoseId"]!//"snooze" + info["inhalerDoseId"]!
                content.userInfo = info
                content.sound = UNNotificationSound.default()//UNNotificationSound(named: "bell.mp3")
                print(date1)
                let trigger = triggerNew //self.setTriggerToParticularDate(dateTime: date1)
                let request = UNNotificationRequest(identifier: info["inhalerDoseId"]!, content: content, trigger: trigger)
                
                
                print("Snooze \(request)")
                self.centre.add(request, withCompletionHandler: nil)
                
            }
        }
    }
    
    
    
    
    func sheduleNotificationForPEFRReminder(date1:Date,info:Dictionary<String,String>,triggerNew:[UNTimeIntervalNotificationTrigger],pEFRReminderDataModel:PEFRReminderDataModel!)
    {
        
        self.centre.getNotificationSettings { (settings) in
            if settings.authorizationStatus != UNAuthorizationStatus.authorized {
                print("Not Authorised")
            } else {
                print("Authorised")
                let content = UNMutableNotificationContent()
                content.title = info["title"] ?? ""
                content.body = info["body"] ?? ""
                UserDefaults.standard.setNotificationCount(value: UserDefaults.standard.getNotificationCount()!+1)
                //content.badge = (UserDefaults.standard.getNotificationCount()! as NSNumber)
                content.categoryIdentifier = "Categeory1"// info["inhalerDoseId"]!
                content.userInfo = info
                content.sound = UNNotificationSound.default()//UNNotificationSound(named: "bell.mp3")
                print(date1)
                let trigger = triggerNew
                
                var identifiersNotification = [String]()
                for trig in trigger
                {
                    //self.setTriggerToParticularDate(dateTime: date1)
                    
                    let identifier = UUID().uuidString
                    identifiersNotification.append(identifier)
                    
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trig)
                    print("Normal \(request)")
                    self.centre.add(request, withCompletionHandler: nil)
                }
                DispatchQueue.main.async {
                    var repeateDays = [Int]()
                    repeateDays.append(contentsOf: pEFRReminderDataModel.repeateDays)
                    DBManager.shared.updatepEFRReminderDataModel(pEFRReminderDataModel: pEFRReminderDataModel, pefrTestDate: pEFRReminderDataModel.pefrTestDate, reminderTiming: pEFRReminderDataModel.reminderTiming, repeateDays:repeateDays , isOn: pEFRReminderDataModel.isOn, identifiersNotification: identifiersNotification)
                }
            }
        }
    }
    func sheduleNotificationForPEFRReminderSnooze(date1:Date,info:Dictionary<String,String>,triggerNew:UNCalendarNotificationTrigger)
    {
        
        self.centre.getNotificationSettings { (settings) in
            if settings.authorizationStatus != UNAuthorizationStatus.authorized {
                print("Not Authorised")
            } else {
                print("Authorised")
                let content = UNMutableNotificationContent()
                content.title = info["title"] ?? ""
                content.body = info["body"] ?? ""
                UserDefaults.standard.setNotificationCount(value: UserDefaults.standard.getNotificationCount()!+1)
                //content.badge = (UserDefaults.standard.getNotificationCount()! as NSNumber)
                content.categoryIdentifier = "Categeory"// info["inhalerDoseId"]!
                content.userInfo = info
                content.sound = UNNotificationSound.default()//UNNotificationSound(named: "bell.mp3")
                print(date1)
                let trigger = triggerNew //self.setTriggerToParticularDate(dateTime: date1)
                let request = UNNotificationRequest(identifier: info["pefrID"] ?? "EMPTY", content: content, trigger: trigger)
                
                print("Normal \(request)")
                self.centre.add(request, withCompletionHandler: nil)
            }
        }
    }
    func setPEFRReminder(pEFRReminderDataModel:PEFRReminderDataModel)  {
        
        let drAppInfo = ["title":"PEFR reminder","body":"Just a remind to you have to add your PEFR Score. at \(pEFRReminderDataModel.reminderTiming!)","dateTime":pEFRReminderDataModel.dateTime,"pefrID":pEFRReminderDataModel.pefrID,"reminderType":"PEFRReminder"]
        
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "dd-MM-yyyy hh:mm a"
        
        var repeateDays = [Int]()
        repeateDays.append(contentsOf: pEFRReminderDataModel.repeateDays)
        
        let dateNew = formatter3.date(from: pEFRReminderDataModel.dateTime)
        //self.sheduleNotificationForPEFRReminder(date1:dateNew ?? Date() , info: drAppInfo as! Dictionary<String, String>, triggerNew: self.getWeeklyTriggre(datetime: dateNew ?? Date(), weekdaySet: repeateDays), pEFRReminderDataModel: pEFRReminderDataModel)
        self.sheduleNotificationForPEFRReminder(date1:dateNew ?? Date() , info: drAppInfo as! Dictionary<String, String>, triggerNew: self.getInstantTriggre(weekdaySet: repeateDays), pEFRReminderDataModel: pEFRReminderDataModel)
    }
    
    func setPEFRReminderSnooze(pEFRReminderDataModel:PEFRReminderDataModel)  {
        
        let drAppInfo = ["title":"PEFR reminder","body":"Just a remind to you have to add your PEFR Score. at \(pEFRReminderDataModel.reminderTiming!)","dateTime":pEFRReminderDataModel.dateTime,"pefrID":"snooze"+pEFRReminderDataModel.pefrID,"reminderType":"PEFRReminder"]
        
        self.sheduleNotificationForPEFRReminderSnooze(date1:Date() , info: drAppInfo as! Dictionary<String, String>, triggerNew: self.getOneMiniuteSnoozeTrigger(snoozeMinute: 10))
    }
    
    func setDRAppoinment(doctorAppointmentDataModel:DoctorAppointmentDataModel)  {
        
        let drAppInfo = ["title":"Dr. Appoinment reminder","body":"Just a remind to you have an appoinment with Dr.\(doctorAppointmentDataModel.doctorName!). at \(doctorAppointmentDataModel.appoinmentTime!)","drName":doctorAppointmentDataModel.doctorName,"dateAndTime":doctorAppointmentDataModel.appoinmentDateAndTime,"appointmentId":doctorAppointmentDataModel.appointmentId,"reminderType":"DrReminder"]
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "dd-MM-yyyy hh:mm a"
        let dateNew = formatter3.date(from: doctorAppointmentDataModel.appoinmentDateAndTime)
        self.sheduleNotificationForDrAppoinment(date1:dateNew ?? Date() , info: drAppInfo as! Dictionary<String, String>, triggerNew: self.setTriggerToParticularDate(dateTime: dateNew ?? Date()))
    }
    func setDRAppoinmentSnooze(doctorAppointmentDataModel:DoctorAppointmentDataModel)  {
        
        let drAppInfo = ["title":"Dr. Appoinment Reminder","body":"Just a reminder to you have an appoinment with Dr.\(doctorAppointmentDataModel.doctorName!). at \(doctorAppointmentDataModel.appoinmentTime!)","drName":doctorAppointmentDataModel.doctorName,"dateAndTime":doctorAppointmentDataModel.appoinmentDateAndTime,"appointmentId":doctorAppointmentDataModel.appointmentId,"reminderType":"DrReminder"]
        self.sheduleNotificationForDrAppoinment(date1: Date() , info: drAppInfo as! Dictionary<String, String>, triggerNew: self.getOneMiniuteSnoozeTrigger(snoozeMinute: 10))
        
    }
    func setInhalerDoseReminder(inhalerReminderDataModel:InhalerReminderDataModel)  {
        
        let drAppInfo = ["title":"Inhaler dose reminder","body":"Hey Just a remind to you have an take dose of '\(inhalerReminderDataModel.device!)'. at \(inhalerReminderDataModel.addTime!).\nMedication: '\(inhalerReminderDataModel.medication!)'\nNumber of puffs: '\(inhalerReminderDataModel.numberOfPuffs!)'\nFrequency: '\(inhalerReminderDataModel.frequency!)'","device":inhalerReminderDataModel.device!,"medication":inhalerReminderDataModel.medication!,"numberOfPuffs":inhalerReminderDataModel.numberOfPuffs!,"frequency":inhalerReminderDataModel.frequency!,"dosageDateTime":inhalerReminderDataModel.dosageDateTime!,"isOn":inhalerReminderDataModel.isOn!,"addTime":inhalerReminderDataModel.addTime!,"inhalerDoseId":inhalerReminderDataModel.inhalerDoseId!,"reminderType":"InhalerDoseReminder"]
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "dd-MM-yyyy hh:mm a"
        let dateNew = formatter3.date(from: inhalerReminderDataModel.dosageDateTime)
        self.sheduleNotificationForInhalerDose(date1:dateNew ?? Date() , info: drAppInfo , triggerNew: self.getDailyTrigger(datetime: dateNew ?? Date()))
    }
    func setInhalerDoseReminderSnooze(inhalerReminderDataModel:InhalerReminderDataModel)  {
        
        let drAppInfo = ["title":"Inhaler dose reminder","body":"Hey Just a remind to you have an take dose of '\(inhalerReminderDataModel.device!)'. at \(inhalerReminderDataModel.addTime!).\nMedication: '\(inhalerReminderDataModel.medication!)'\nNumber of puffs: '\(inhalerReminderDataModel.numberOfPuffs!)'\nFrequency: '\(inhalerReminderDataModel.frequency!)'","device":inhalerReminderDataModel.device!   ,"medication":inhalerReminderDataModel.medication!,"numberOfPuffs":inhalerReminderDataModel.numberOfPuffs!,"frequency":inhalerReminderDataModel.frequency!,"dosageDateTime":inhalerReminderDataModel.dosageDateTime!,"isOn":inhalerReminderDataModel.isOn!,"addTime":inhalerReminderDataModel.addTime!,"inhalerDoseId":"snooze"+inhalerReminderDataModel.inhalerDoseId!,"reminderType":"InhalerDoseReminder"]
        self.sheduleNotificationForInhalerDoseSnooze(date1: Date() , info: drAppInfo, triggerNew: self.getOneMiniuteSnoozeTrigger(snoozeMinute: 10))
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Test: \(response.notification.request.content.userInfo)")
        let responseDic = response.notification.request.content.userInfo
        switch response.actionIdentifier
        {
        case "Remind me later":
            print("Remind me later")
            completionHandler()
            
            if let reminderType = responseDic["reminderType"] as? String
            {
                if reminderType == "DrReminder"
                {
                    if let appointmentId = responseDic["appointmentId"] as? String
                    {
                        let temp = DBManager.shared.getDoctorAppointmentDataModel(appoinmentId: appointmentId)
                        if temp.count != 0
                        {
                            self.setDRAppoinmentSnooze(doctorAppointmentDataModel: temp[0])
                        }
                        
                    }
                    
                }
                else
                    if reminderType == "InhalerDoseReminder"
                    {
                        if let inhalerDoseId = responseDic["inhalerDoseId"] as? String
                        {
                            let nn = inhalerDoseId.replacingOccurrences(of: "snooze", with: "")
                            let temp = DBManager.shared.getInhalerReminderDataModel(inhalerDoseId: nn)
                            if temp.count != 0
                            {
                                let temp1 = temp[0]
                                self.setInhalerDoseReminderSnooze(inhalerReminderDataModel: temp1)
                                
                            }
                            
                        }
                        
                    }
                    else
                        if reminderType == "PEFRReminder"
                        {
                            if let inhalerDoseId = responseDic["pefrID"] as? String
                            {
                                let nn = inhalerDoseId.replacingOccurrences(of: "snooze", with: "")
                                let temp = DBManager.shared.getPEFRReminderDataModel(pefrID: nn)
                                if temp.count != 0
                                {
                                    let temp1 = temp[0]
                                    self.setPEFRReminderSnooze(pEFRReminderDataModel: temp1)
                                    
                                }
                                
                            }
                }
            }
            
        case "Yes":
            print("Yes")
            completionHandler()
            if let reminderType = responseDic["reminderType"] as? String
            {
                if reminderType == "DrReminder"
                {
                    if let appointmentId = responseDic["appointmentId"] as? String
                    {
                        
                        
                        let temp1 = DBManager.shared.getDoctorAppointmentDataModel(appoinmentId: appointmentId)
                        if temp1.count != 0
                        {
                            let temp = temp1[0];
                            DBManager.shared.updateDoctorAppointmentDataModel(doctorAppointmentDataModel: temp, doctorName: temp.doctorName, appoinmentDate: temp.appoinmentDate, appoinmentTime: temp.appoinmentTime, isAppoinmentComplete: "YES")
                        }
                        
                    }
                    
                }
            }
            
            
        case "No":
            print("No")
            completionHandler()
            if let reminderType = responseDic["reminderType"] as? String
            {
                if reminderType == "DrReminder"
                {
                    if let appointmentId = responseDic["appointmentId"] as? String
                    {
                        let temp1 = DBManager.shared.getDoctorAppointmentDataModel(appoinmentId: appointmentId)
                        if temp1.count != 0
                        {
                            let temp = temp1[0];
                            DBManager.shared.updateDoctorAppointmentDataModel(doctorAppointmentDataModel: temp, doctorName: temp.doctorName, appoinmentDate: temp.appoinmentDate, appoinmentTime: temp.appoinmentTime, isAppoinmentComplete: "NO")
                        }
                        
                    }
                    
                }
            }
            
            
        default:
            print("default")
            completionHandler()
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Test Foreground: \(notification.request.identifier)")
        
        completionHandler([.alert, .sound,.badge])
    }
    
}


enum UserDefaultsKeys : String
{
    case notificationCount
    
}
extension UserDefaults
{
    func setNotificationCount(value: Int)
    {
        set(value, forKey: UserDefaultsKeys.notificationCount.rawValue)
        synchronize()
    }
    func getNotificationCount() -> Int?
    {
        return integer(forKey: UserDefaultsKeys.notificationCount.rawValue)
    }
}
*/
