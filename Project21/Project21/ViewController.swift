//
//  ViewController.swift
//  Project21
//
//  Created by Domagoj Sutalo on 18.08.2021..
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setBarButtons()
    }
    
    @objc func registerLocal(){
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]){ granted, error in
            if granted{
                print("Yey")
            } else{
                print("Dang")
            }
        }
    }
    
    @objc func defaultSchedule(){
        scheduleLocal(timeInterval: 5)
    }
    // adding parameter in method so we can snooze notification for entered value of seconds
    @objc func scheduleLocal(timeInterval: Double){
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
//        var dateComponents = DateComponents()
//        dateComponents.hour = 10
//        dateComponents.minute = 30
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
    }
    
    func registerCategories(){
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let snooze = UNNotificationAction(identifier: "snooze", title: "Remind me later", options: .destructive)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, snooze], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            //challenge 1
            switch response.actionIdentifier{
            case UNNotificationDefaultActionIdentifier:
                callAlertController(title: "Swiped", message: "User swiped to open the app")
                
            case "show":
                callAlertController(title: "Show tapped", message: "User tapped the button to open the app")
            
            case "snooze":
                //challenge 2
                scheduleLocal(timeInterval: 86400) //snoozing for 86400 seconds - 1 day
                
            default:
                break
            }
        }
        completionHandler()
    }
    
    func callAlertController(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    func setBarButtons(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(defaultSchedule))
    }
}

