//
//  AppDelegate.swift
//  SIS App
//
//  Created by Wang Yunze on 17/10/20.
//

import CoreData
import Firebase
import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate = self

        print("🔥 Configuring firebase..")
        FirebaseApp.configure()
        // Functions.functions().useEmulator(withHost: "localhost", port: 5001)
        IntersectionChecker.`init`()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
          The persistent container for the application. This implementation
          creates and returns a container, having loaded the store for the
          application to it. This property is optional since there are legitimate
          error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "SIS_App")
        container.loadPersistentStores(completionHandler: { _, error in
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

    func saveContext() {
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

// MARK: User Notification Delegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let identifier = notification.request.identifier
        print("📣 app delegate: will present user notification: \(identifier)")

        switch identifier {
        case Constants.didEnterSchoolNotificationIdentifier:
            print("📣 start updating location...")
            sceneDelegate?.userLocationManager.locationManager.startUpdatingLocation()
        case Constants.didExitSchoolNotificationIdentifier:
            print("📣 stop updating location...")
            sceneDelegate?.userLocationManager.locationManager.stopUpdatingLocation()
        default:
            break
        }

        completionHandler(UNNotificationPresentationOptions.banner)
    }

    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.notification.request.identifier
        print("📣 app delegate: did receive user notification: \(identifier)")

        switch identifier {
        case Constants.didExitSchoolNotificationIdentifier:
            fallthrough
        case Constants.didEnterSchoolNotificationIdentifier:
            sceneDelegate?.navigationState.shouldShowSafariView = true
        case Constants.remindUserCheckOutNotificationIdentifier:
            sceneDelegate?.navigationState.tabbarSelection = .home
        case Constants.remindUserFillInRoomsNotificationIdentifier:
            sceneDelegate?.navigationState.tabbarSelection = .history
        default:
            break
        }

        completionHandler()
    }
}

extension AppDelegate {
    var sceneDelegate: SceneDelegate? { UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate }
}
