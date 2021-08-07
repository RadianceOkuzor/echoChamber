//
//  ViewController.swift
//  KingsEcho
//
//  Created by Radiance Okuzor on 8/4/21.
//

import UIKit
import Firebase
import Firebase
import FirebaseFunctions
import FirebaseFirestore

class PublishVC: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var authorInput: UITextField!
    @IBOutlet weak var translatorInput: UITextField!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var postStackView: UIStackView!
    
    var ref: DatabaseReference!
    var firestoreRef: DocumentReference?
    var db: Firestore!
    
    var messages = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        ref = Database.database().reference()
        db = Firestore.firestore()
        
//        postsReference = ref.child("Posts")
        setUpListeners()
    }
    
    func setUpListeners(){
        db.collection("Articles").addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot?.documents else {
                print("Error fetching document: \(error!)")
                return
              }
            self.messages.removeAll()
                for x in document {
                    let data = x.data()
                    let article = Article()
                    if let author = data["author"] as? String {
                        article.author = author
                    } else {
                        article.author = "incognito"
                    }
                    if let id = data["id"] as? String {
                        article.id = id
                    }
                    if let message = data["message"] as? String {
                        article.message = message
                    } else if let message = data["post"] as? String {
                        article.message = message
                    }
                    if let originalPublisherId = data["originalPublisherId"] as? String {
                        article.originalPublisherId = originalPublisherId
                    }
                    if let translator = data["translator"] as? String {
                        article.translatorName = translator
                    }
                    self.messages.append(article)
                }
            self.tableView.reloadData()
            }
    }
    
    
    @IBAction func newPost(_ sender: Any) {
        postStackView.isHidden = (postStackView.isHidden == true) ? (false) : (true)
    }
    
    @IBAction func publishPost(_ sender: Any) {
        // save to firebase
        let publisher = Auth.auth().currentUser!.uid
        let articleRef = db.collection("Articles").document()
        let docId = articleRef.documentID
        
        let postDict = ["author":authorInput.text!,
                        "translator":translatorInput.text!,
                        "id":docId,
                        "message":postText.text!,"originalPublisherId":publisher] as [String : Any]
        
 
       
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
                print("Document successfully written! for article")
            }
        } 
        
        postStackView.isHidden = (postStackView.isHidden == true) ? (false) : (true)
    }
    
    func manuallyPublishArticle(post:Article){
        
        let postDict = ["author":post.author,
                        "translatorName":post.translatorName,
                        "id":post.id,
                        "message":post.message,
                        "originalPublisherId":post.originalPublisherId]
        
        Functions.functions().httpsCallable("manuallyPublishArticle").call(postDict)  { (result, err) in
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
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postsTableView", for: indexPath)
        cell.textLabel?.text = messages[indexPath.row].author
        return cell 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        manuallyPublishArticle(post: messages[indexPath.row])
        print("message sent to server")
    }
}

