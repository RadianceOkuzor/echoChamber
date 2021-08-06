//
//  Post.swift
//  KingsEcho
//
//  Created by Radiance Okuzor on 8/5/21.
//

import Foundation

class Article {
    var author: String
    var id: String
    var originalPublisherId: String
    var message: String
    var translator: String
    var likes: [String]
    var language: String
    var articleTranslations: [Article]
    var timeStamp: Date
    
    init() {
        author = ""
        id = ""
        originalPublisherId = ""
        message = ""
        translator = ""
        likes = []
        language = ""
        articleTranslations = []
        timeStamp = nil
    }
}

class User {
    var id: String
    var name: String
    var phoneNumber: String
    var age: Int
    var nationality: Int 
    var email: String
    var myArticles: [Article]
    var mySubscribers: [String] // list of user id of people who need to get notified of my articles
    var mySubscription: [String] //this is a list of the echochambers i am a part of
}
 
