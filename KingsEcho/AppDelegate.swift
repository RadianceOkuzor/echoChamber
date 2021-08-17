//
//  AppDelegate.swift
//  KingsEcho
//
//  Created by Radiance Okuzor on 8/4/21.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

 
    var db: Firestore!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        db = Firestore.firestore()
        setUpUserData()
        IQKeyboardManager.shared.enable = true
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
    
    func setUpUserData() {
        let myId = Auth.auth().currentUser!.uid
        let docRef = db.collection("Users").document(myId)

        docRef.addSnapshotListener { (document, error) in
            if let document = document, document.exists {
                
                if let data = document.data() {
                    if let name = data["name"] as? String {
                        UserData.shared.name = name
                    }
                    if let email = data["email"] as? String {
                        UserData.shared.email = email
                    }
                    if let phoneNumber = data["phoneNumber"] as? String {
                        UserData.shared.phoneNumber = phoneNumber
                    }
                    if let language = data["language"] as? String {
                        UserData.shared.language = language
                    }
                    if let phoneNumbers = data["mySubscribers"] as? [String:[String:AnyObject]]{
                        UserData.shared.subscribersPhoneNumbers = Array(phoneNumbers.keys)
                    }
                    if let mySubscriptions = data["mySubscriptions"] as? [String:String]{
                        UserData.shared.mySubscriptions = mySubscriptions
                    }
                }
                  
            } else {
                print("Document does not exist")
            }
        }
    }


}

