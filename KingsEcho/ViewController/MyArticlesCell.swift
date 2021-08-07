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

class MyArticlesCell: FoldingCell {
 
    @IBOutlet weak var publisherInitialsClosed: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
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
    var likeCount = 0
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
        likeCount += 1
        likesCountLabel.text = String(likeCount)
    }
    
    @IBAction func echoPrsd(_ sender: Any) {
        
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
            let dict = ["subscriberName":UserData.shared.phoneNumber,
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
}

// MARK: - Actions ⚡️

extension MyArticlesCell {

    @IBAction func buttonHandler(_: AnyObject) {
        print("tap")
    }
}
