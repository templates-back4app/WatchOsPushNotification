//
//  WatchOS_Push_NotificationApp.swift
//  WatchOS Push Notification Watch App
//
//  Created by Alex on 13/05/24.
//

import SwiftUI
import WatchKit
import UserNotifications
import ParseSwift

// Main entry point of the WatchOS App
@main
struct WatchOS_Push_Notification_Watch_AppApp: App {
    @WKExtensionDelegateAdaptor(ExtensionDelegate.self) var extensionDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// ExtensionDelegate to handle lifecycle events and notification registration
class ExtensionDelegate: NSObject, WKExtensionDelegate, UNUserNotificationCenterDelegate {
    func applicationDidFinishLaunching() {
        // Request notification permissions
        NotificationManager.shared.requestAuthorization()
    }

    func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data) {
        print("Running didRegisterForRemoteNotifications")
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        UserDefaults.standard.set(token, forKey: "deviceToken")
    }

    func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Notification response received with userInfo: \(response.notification.request.content.userInfo)")
        completionHandler()
    }
}

// Manages notification interactions
class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    // Requests notification permissions from the user
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error)")
            } else {
                print("Notification permission granted: \(granted)")
                if granted {
                    // Registers the application with APNs to receive remote notifications
                    DispatchQueue.main.async {
                        print("Calling dispatch")
                        WKExtension.shared().registerForRemoteNotifications()
                    }
                }
            }
        }
    }
}
