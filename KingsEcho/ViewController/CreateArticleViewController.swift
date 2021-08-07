//
//  CreateArticleViewController.swift
//  KingsEcho
//
//  Created by Radiance Okuzor on 8/7/21.
//


import UIKit
import Firebase
import FirebaseFunctions
import FirebaseFirestore

class CreateArticleViewController: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    @IBOutlet weak var translatorField: UITextField!
    @IBOutlet weak var message: UITextView!

    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        db = Firestore.firestore()
    }
     
    @IBAction func publishPost(_ sender: Any) {
        // save to firebase
        let publisher = Auth.auth().currentUser!.uid
        let articleRef = db.collection("Articles").document()
        let docId = articleRef.documentID
        
        let postDict = ["author":authorField.text!,
                        "translatorName":translatorField.text ?? "",
                        "translatorId":"",
                        "id":docId,
                        "message":message.text!,
                        "originalPublisherId":publisher,
                        "title":titleField.text,
                        "echoesCount":"",
                        "likesCount":"",
                        "publisherName":UserData.shared.name] as [String : Any]
        
 
       
        let userArticle = ["myArticles": [docId:docId]]
         
        db.collection("Users").document(publisher).setData(userArticle, merge: true) { err in
            if let err = err {
                print("Error writing document for user: \(err)")
            } else {
                print("Document successfully written for user!")
            }
        }
        
        articleRef.setData(postDict) { err in
            if let err = err {
                print("Error writing document for article:  \(err)")
            } else {
                self.sendPayLoadToServer()
                self.authorField.text = ""
                self.translatorField.text = ""
                self.message.text = ""
                self.titleField.text = ""
                print("Document successfully written! for article")
            }
        }
    }
    
    func sendPayLoadToServer(){
        let postDict = ["author":authorField.text,
                        "publisherName":UserData.shared.name,
                        "message":message.text!,
                        "title":titleField.text!,
                        "numbers": UserData.shared.subscribersPhoneNumbers] as [String : Any]
        
        Functions.functions().httpsCallable("manuallyPublishArticle").call(postDict)  { (result, err) in
            print("____resutl.data is\n \(result?.data)")
            if  err != nil {
                print("____Message wasn't manually sent  \(err?.localizedDescription)")
            } else {
//                print("this is ")
            }
        }
    }
}
