//
//  ViewController.swift
//  Notifications
//
//  Created by Matthew Newill on 10/05/2017.
//  Copyright © 2017 Mobient. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       

        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { (notifications) in
            print("Count: \(notifications.count)")
            for item in notifications {
                print(item.trigger)
            }
        }
        
    }
    @IBAction func sendNotificationIn5Seconds() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.sendNotificationIn5Seconds()
    }

    @IBAction func dateSet(_ sender: UIDatePicker) {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.sheduleNotification(date1: sender.date)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
