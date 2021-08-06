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

class PublishVC: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var authorInput: UITextField!
    @IBOutlet weak var translatorInput: UITextField!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var postStackView: UIStackView!
    
    var ref: DatabaseReference!
    
    var posts = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        ref = Database.database().reference()
        postsReference = ref.child("Posts")
    }
    
    private var postsReference:DatabaseReference? {
        didSet{
            ref.child("Articles").observe(DataEventType.value, with: { (snapshot) in
                if let postData = snapshot.value as? [String : AnyObject] {
                    print(postData)
                    var post = Article()
                    
                    for (a,b) in postData {
                        if let author = b["author"] as? String {
                            post.author = author
                        }
                        if let id = b["id"] as? String {
                            post.id = id
                        }
                        if let posts = b["post"] as? String {
                            post.post = posts
                        }
                        if let originalPublisherId = b["originalPublisherId"] as? String {
                            post.originalPublisherId = originalPublisherId
                        }
                        if let translator = b["translator"] as? String {
                            post.translator = translator
                        }
                        self.posts.append(post)
                    }
                    self.tableView.reloadData()
                     
                }
                
            })
        }
    }
    
    
    @IBAction func newPost(_ sender: Any) {
        postStackView.isHidden = (postStackView.isHidden == true) ? (false) : (true)
    }
    
    @IBAction func publishPost(_ sender: Any) {
        // save to firebase
        let postId = ref.childByAutoId().key!
        let publisher = Auth.auth().currentUser!.uid
        
        let postDict = ["author":authorInput.text!,
                        "translator":translatorInput.text!,
                        "id":postId,
                        "post":postText.text!,"originalPublisherId":publisher] as [String : Any]
        
        self.ref.child("Articles").child("\(postId)").setValue(postDict)
        self.ref.child("Users").child(publisher).child("MyPosts").updateChildValues([postId:postId])
        postStackView.isHidden = (postStackView.isHidden == true) ? (false) : (true)
    }
    
    func manuallyPublishArticle(post:Article){
        
        let postDict = ["author":post.author,
                        "translator":post.translator,
                        "id":post.id,
                        "post":post.message,
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
    
}

extension PublishVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postsTableView", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].author
        return cell 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        manuallyPublishArticle(post: posts[indexPath.row])
        print("message sent to server")
    }
}

