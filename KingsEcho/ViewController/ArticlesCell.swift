//
//  ArticlesCell.swift
//  KingsEcho
//
//  Created by Radiance Okuzor on 8/6/21.
//
 
import Firebase
import FirebaseFirestore
import FoldingCell
import UIKit

class ArticlesCell: FoldingCell {
 
    @IBOutlet weak var publisherInitialsClosed: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorLabelOpen: UILabel!
    @IBOutlet weak var echoesCountLabel: UILabel!
    @IBOutlet weak var echoesCountLabelClosed: UILabel!
    @IBOutlet weak var translatorsLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var publisherNameLabel: UILabel!
    @IBOutlet weak var publisherInitials: UILabel!
    @IBOutlet weak var publisherIcon: UIImageView!
    @IBOutlet weak var messageTitleLabel: UILabel!
    @IBOutlet weak var messageTitleOpen: UILabel!
    @IBOutlet weak var subscribeBtn: UIButton!
    @IBOutlet weak var messageBodyLabel: UITextView!
    @IBOutlet weak var echoBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    
    var db: Firestore!
    var publisherId = String()
    var articleId = String()
    var likeCount = 0
    var messageTranslation = [String:String]()
    var number: Int = 0 {
        didSet {
//            PublisherInitials.text = String(number)
//            openNumberLabel.text = String(number)
        }
    }

    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        db = Firestore.firestore()
        super.awakeFromNib()
    }

    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    @IBAction func likePrsd(_ sender: Any) {
        //Show different translation
        if likeCount < messageTranslation.count {
            let translation = messageTranslation.index(messageTranslation.startIndex, offsetBy: likeCount)
            
             
            let key = Array(messageTranslation.keys)[likeCount]
            let value = Array(messageTranslation.values)[likeCount]
            
            
            var text = "Message translated to \(returnLange(string: key))\n"
            text.append(value)
            self.messageBodyLabel.text = text
            likeCount += 1
        } else {
            likeCount = 0
        }
        
        
    }
    
    func returnLange(string:String) -> String{
        var lan = "English"
        if string == "en" {
            lan = "English"
        } else if string == "es" {
            lan = "Spanish"
        } else if string == "de" {
            lan = "Duecth"
        } else if string == "fr" {
            lan = "French"
        } else if string == "ru" {
            lan = "Russian"
        } else if string == "ro" {
            lan = "Romanian"
        } else if string == "ig" {
            lan = "Igbp"
        }
        return lan
    }
    
    @IBAction func echoPrsd(_ sender: Any) {
        sendPayLoadToServer()
        let echoDict = ["echoesCount": UserData.shared.subscribersPhoneNumbers]
        db.collection("Articles").document(articleId).setData(echoDict, merge: true) { err in
            if let err = err {
                print("Error writing document for user: \(err)")
            } else {
                print("Document successfully written for user!")
            }
        }
    }
    
    @IBAction func subscribePrsd(_ sender: Any) {
        // add user to my subscriptionObjection
        let mySubscription = ["mySubscriptions": [publisherId:publisherId]]
        let myId = Auth.auth().currentUser!.uid
        
        if myId != publisherId {
            db.collection("Users").document(myId).setData(mySubscription, merge: true) { err in
                if let err = err {
                    print("Error writing document for user: \(err)")
                } else {
                    print("Document successfully written for user!")
                }
            }
            
            //add subscriber this user to the publisher's subscribers
            let dict = ["subscriberName":UserData.shared.name,
                            "subscriberPhoneNumber":UserData.shared.phoneNumber] as [String : Any]
            
            let mySubscribers = ["mySubscribers": [UserData.shared.phoneNumber:dict]]
            db.collection("Users").document(publisherId).setData(mySubscribers, merge: true) { err in
                if let err = err {
                    print("Error writing document for user: \(err)")
                } else {
                    print("Document successfully written for user!")
                }
            }
        } else {
            
        }
    }
    
    func sendPayLoadToServer(){
        let postDict = ["author":authorLabel.text,
                        "publisherName":publisherNameLabel.text,
                        "message":messageBodyLabel.text!,
                        "title":messageTitleOpen.text!,
                        "numbers": UserData.shared.subscribersPhoneNumbers] as [String : Any]
        
        Functions.functions().httpsCallable("manuallyPublishArticle").call(postDict)  { (result, err) in
            print("____resutl.data is\n \(result?.data)")
            if  err != nil {
                print("____Message wasn't manually sent  \(err?.localizedDescription)")
            } else {

            }
        }
    }
}

// MARK: - Actions ⚡️

extension ArticlesCell {

    @IBAction func buttonHandler(_: AnyObject) {
        print("tap")
    }
}
