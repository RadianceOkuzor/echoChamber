//
//  SharedResources.swift
//  KingsEcho
//
//  Created by Radiance Okuzor on 8/6/21.
//

import Foundation

class UserData {
    
    static let shared = UserData()
    
    var locationGranted: Bool?
    var name: String?
    var email: String?
    var phoneNumber: String?
    var language: String?
    var subscribersPhoneNumbers: [String]?
    var mySubscriptions: [String:String]?
    var subscriptions: [User]?
    var mySubscribers: [User]?
    var articles: [Article]?
    //Initializer access level change now
    init(){}
    
    func requestForLocation(){
        //Code Process
        locationGranted = true
        print("Location granted")
    }
    
}
