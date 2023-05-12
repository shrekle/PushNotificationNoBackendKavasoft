//
//  PushNotificationNoBackendKavasoftApp.swift
//  PushNotificationNoBackendKavasoft
//
//  Created by nan on 5/11/23.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging

@main
struct PushNotificationNoBackendKavasoftApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    let gcmMessageIDKey = "gcm.message_id"
    
    //tells the delegate that the app that the launching process is almost done and the app is almost ready to launch
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
                
        //this asks the user if he wants to allow notifications at the start of the app
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]//this is the list of the type of notifications that the app is requesting to have
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions,completionHandler: {_, _ in })
        
        Messaging.messaging().delegate = self // this sets up cloud messaging
        
        UNUserNotificationCenter.current().delegate = self
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let messaegID = userInfo[gcmMessageIDKey] {
            print("message ID: \(messaegID)")
        }
        
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
        
    }
    
    //recieve notifications you need to implement deez methods
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
}

extension AppDelegate: MessagingDelegate {
    
    //this monitors token refresh
    // Note: This callback is fired at each app startup and whenever a new token is generated.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
        
        //not sure what this code is for, came from firebase docs
//      NotificationCenter.default.post(
//        name: Notification.Name("FCMToken"),
//        object: nil,
//        userInfo: dataDict
//      )
        
        print(dataDict)
      // store token in firestore for sending notifications from server in future
      //make a check to update the token in the user profile when the token has been refreshed by firebase
    }
    
}

//user notificaiton AKA inApp notifications
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    //this is to present notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            
        }
    }
}
