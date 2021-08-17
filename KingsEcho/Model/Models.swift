//
//  Post.swift
//  KingsEcho
//
//  Created by Radiance Okuzor on 8/5/21.
//

import Foundation
import Firebase
import FirebaseFirestore

class Article {
    var author: String
    var id: String
    var originalPublisherId: String
    var publisherName: String?
    var title: String
    var message: String
    var messageTranslated: [String:String]?
    var translatorName: String?
    var translatorId: String?
    var likes: [String]
    var language: String
    var articleTranslations: [Article]
    var timeStamp: Date
    var linkToPubImage: String?
    var linkToArticleImage: String?
    var echoesCount: Int?
    
    init() {
        author = ""
        id = ""
        originalPublisherId = ""
        message = ""
        likes = []
        language = ""
        articleTranslations = []
        title = ""
        timeStamp = Date()
    }
}

class User {
    var id: String?
    var name: String?
    var phoneNumber: String?
    var age: Int?
    var nationality: Int?
    var language: String?
    var email: String!
    var myArticles: [Article]?
    var mySubscribers: [String]? // list of user id of people who need to get notified of my articles
    var mySubscription: [String]? //this is a list of the echochambers i am a part of
    
    func getSubscribers(document:[QueryDocumentSnapshot]) -> [User] {
        var subscriptions = [User]()
        
        let mysubs = UserData.shared.mySubscriptions
        subscriptions.removeAll()
        if let subs = mysubs?.isEmpty, !subs {
            let mysubsar = Array(mysubs!.keys)
            for x in document{
                let suber = User()
                let data = x.data()
                if let userId = data["id"] as? String {
                    if mysubsar.contains(userId) {
                        if let name = data["name"] as? String {
                            suber.name = name
                        }
                        if let email = data["email"] as? String {
                            suber.email = email
                        }
                        if let phoneNumber = data["phoneNumber"] as? String {
                            suber.phoneNumber = phoneNumber
                        }
                        subscriptions.append(suber)
                    }
                }
            }
            return subscriptions
        }
        return []
    }
}
 
