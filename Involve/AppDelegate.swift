//
//  AppDelegate.swift
//
//  Team Members: Sid Rath (sidrath@iu.edu)
//                Diego Rios-Rojas (dariosro@iu.edu)
//                Shaun Trimm (strimm@iu.edu)
//  Project Name: Involve
//  Final Project Submission Date: May 4, 2021
//
import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    let involveModel : InvolveDataModel = InvolveDataModel()
    var window: UIWindow?
    
    //show notification even if app is open
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        //request notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {
            (granted, error) in
            //print("granted: \(granted)")
        }
        
        // Override point for customization after application launch.
        
        //read favorite events file favoriteEvents.plist
        
        //read file if exists
        do {
            let fm = FileManager.default
            let docsurl = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let remFile = docsurl.appendingPathComponent("favoriteEvents.plist")
            let plister = PropertyListDecoder()
            
            let data = try Data(contentsOf: remFile)
            let favoritesStoredData = try plister.decode([Event].self, from: data)
            self.involveModel.favoriteEvents = favoritesStoredData
        }
        catch{
            self.involveModel.favoriteEvents = []
        }
        
        //for all events in the favoriteEvents, set the corresponding isFavorite field for the event in events to true
        for x in involveModel.favoriteEvents {
            for y in involveModel.events {
                if((x.name == y.name) && (x.details ==  y.details)){
                    y.isFavorite = true
                }
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

