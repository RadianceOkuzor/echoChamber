//
//  GameServerSingleton.swift
//  KingsEcho
//
//  Created by Radiance Okuzor on 8/5/21.
//

import Foundation
import Firebase
import FirebaseDatabase


protocol ArticleServerDelegate:AnyObject {
    func updateMySubscriptions()
    func updateMySubscribers()
    func updateArticles()
}

class ArticleServerSingleton {
    
    var ref: DatabaseReference!
    var firestoreRef: DocumentReference?
    var db: Firestore!
    
    static let shared = ArticleServerSingleton()
      
    var delegate:ArticleServerDelegate?
     
    func fetchSubscriptions() {
        ref = Database.database().reference()
        db = Firestore.firestore()
        
        db.collection("Users").addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot?.documents else {
              print("Error fetching document: \(error!)")
              return
            }
            UserData.shared.subscriptions = self.getUsers(document: document)
            self.delegate?.updateMySubscriptions()
        }
    }
    
    func fetchMyEchoChamber() {
        let uid = Auth.auth().currentUser?.uid
        db = Firestore.firestore()
        db.collection("Users").document(uid ?? "").addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
            
            UserData.shared.mySubscribers = self.getMySubers(document: document)
            self.delegate?.updateMySubscribers()
        }
    }
    
    func fetchArticles(){
        var articles = [Article]()
        db = Firestore.firestore()
        db.collection("Articles").addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot?.documents else {
                print("Error fetching document: \(error!)")
                return
              }
            articles.removeAll()
                for x in document {
                    let data = x.data()
                    let article = Article()
                    if let author = data["author"] as? String {
                        article.author = author
                    }
                    if let id = data["id"] as? String {
                        article.id = id
                    }
                    if let messageT = data["messageTranslated"] as? [String:String] {
                        article.messageTranslated = messageT
                    }
                    if let message = data["message"] as? String {
                        article.message = message
                    }
                    if let messageTitle = data["title"] as? String {
                        article.title = messageTitle
                    }
                    if let echoesCount = data["echoesCount"] as? [String] {
                        article.echoesCount = echoesCount.count
                    }
                    if let likesCount = data["likesCount"] as? [String] {
                        article.likes = likesCount
                    }
                    if let originalPublisherId = data["originalPublisherId"] as? String {
                        article.originalPublisherId = originalPublisherId
                    }
                    if let publisherName = data["publisherName"] as? String {
                        article.publisherName = publisherName
                    }
                    if let translator = data["translatorName"] as? String {
                        article.translatorName = translator
                    }
                    articles.append(article)
                }
            UserData.shared.articles = articles
            self.delegate?.updateArticles()
            }
    }
    
    func getMySubers(document:DocumentSnapshot) -> [User]{
        var subscribers = [User]()
        subscribers.removeAll()
        if let x = document["mySubscribers"] as? [String:[String:AnyObject]] {
            for (a,b) in x {
                let user = User()
                if let name = b["subscriberName"] as? String {
                    user.phoneNumber = a
                    user.name = name
                }
                subscribers.append(user)
            }
            return subscribers
        }
        return []
    }
    
    func getUsers(document:[QueryDocumentSnapshot]) -> [User] {
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
