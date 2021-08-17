//
//  ViewController.swift
//  KingsEcho
//
//  Created by Radiance Okuzor on 8/4/21.
//

import UIKit
import Firebase
import FirebaseFunctions
import FirebaseFirestore

extension PublishVC: ArticleServerDelegate {
    func updateArticles() {
         
    }
    
    func updateMySubscriptions() {
        subscriptions = UserData.shared.subscriptions ?? []
        self.tableView2.reloadData()
    }
    
    func updateMySubscribers() {
        subscribers = UserData.shared.mySubscribers ?? []
        self.tableView.reloadData()
    }
}

class PublishVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var authorInput: UITextField!
    @IBOutlet weak var translatorInput: UITextField!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var postStackView: UIStackView!
    @IBOutlet weak var addSubBtn: UIButton!
    @IBOutlet weak var addNewPersonView: UIView!
    @IBOutlet weak var subscriberNameText: UITextField!
    @IBOutlet weak var subscriberPhoneNumber: UITextField!
    
    
    var ref: DatabaseReference!
    var firestoreRef: DocumentReference?
    var db: Firestore!
    
    var subscribers = [User]()
    var subscriptions = [User]()
    var articleDelegate:ArticleServerSingleton?
     

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView2.delegate = self
        tableView2.dataSource = self
        tableView.backgroundColor = .clear
        tableView2.backgroundColor = .clear
        addSubBtn.layer.cornerRadius = 10
        addNewPersonView.layer.cornerRadius = 10
        ref = Database.database().reference()
        db = Firestore.firestore()
        ArticleServerSingleton.shared.delegate = self
        ArticleServerSingleton.shared.fetchSubscriptions()
        ArticleServerSingleton.shared.fetchMyEchoChamber()
        
    }
    
    
    @IBAction func newPost(_ sender: Any) {
//        try! Auth.auth().signOut()
//        performSegue(withIdentifier: "showsignup", sender: nil)
        addNewPersonView.isHidden = (addNewPersonView.isHidden == true) ? (false) : (true)
    }
    
    @IBAction func addNewPersonPressed(_ sender: Any) {
         
        let dict = ["subscriberName":subscriberNameText.text!,
                        "subscriberPhoneNumber":subscriberPhoneNumber.text!] as [String : Any]
        
        let mySubscribers = ["mySubscribers": [subscriberPhoneNumber.text!:dict]]
        let publisher = Auth.auth().currentUser!.uid
        
        db.collection("Users").document(publisher).setData(mySubscribers, merge: true) { err in
            if let err = err {
                print("Error writing document for user: \(err)")
            } else {
                print("Document successfully written for user!")
                self.sendWelcomeToChamberMessage()
            }
        }
        addNewPersonView.isHidden = (addNewPersonView.isHidden == true) ? (false) : (true)
 
    }
    

    
    func sendWelcomeToChamberMessage(){
        let postDict = [
                        "publisherName":UserData.shared.name,
                        "numbers": subscriberPhoneNumber.text!] as [String : Any]
        
        Functions.functions().httpsCallable("sendWelcomeMessageToSubscriber").call(postDict)  { (result, err) in
            print("____resutl.data is\n \(result?.data)")
            if  err != nil {
                print("____Message wasn't manually sent  \(err?.localizedDescription)")
            } else {
//                print("this is ")
            }
        }
    }
    
    
    @IBAction func signOut(_ sender: Any) {
        if let authUser = Auth.auth().currentUser {
            self.performSegue(withIdentifier: "publishViewToSignIn", sender: nil)
            do {
                try? Auth.auth().signOut()
                print("signed out")
            } catch  {
                print("sign out didnt work")
            }
            
        }
    }
    
}

extension PublishVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView2 {
            return subscriptions.count 
        } else {
            return subscribers.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableView2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postsTableView2", for: indexPath) as! ChamberTableViewCell
            cell.subscriptionName.text = subscriptions[indexPath.row].name
            cell.imageViweCellSubscription?.image = #imageLiteral(resourceName: "photo")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postsTableView", for: indexPath) as! ChamberTableViewCell
            cell.subscriberName.text = subscribers[indexPath.row].name
            cell.imageVIewCell?.image = #imageLiteral(resourceName: "photo")
            return cell
        }
         
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        manuallyPublishArticle(post: messages[indexPath.row])
        print("message sent to server")
    }
    
     func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
