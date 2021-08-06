//
//  SignUpVC.swift
//  KingsEcho
//
//  Created by Radiance Okuzor on 8/4/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFunctions
import FirebaseFirestore

class SignUpVC: UIViewController {
    
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var language: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    var firestoreRef: DocumentReference?
    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        db = Firestore.firestore()
    }

    @IBAction func signUp(_ sender:UIButton){
        Auth.auth().createUser(withEmail: emailLabel.text!, password: passwordLabel.text!) { authResult, error in
          // ...
            if let user = authResult?.user {
              // The user's ID, unique to the Firebase project.
              // Do NOT use this value to authenticate with your backend server,
              // if you have one. Use getTokenWithCompletion:completion: instead.
              let uid = user.uid
              let email = user.email
                let userDict = ["name":self.name.text!,
                                "email":self.emailLabel.text!,
                                "id":uid,
                                "phoneNumber":self.phoneNumber.text!,"language":self.language.text!] as [String : Any]
                
                self.db.collection("Users").document(uid).setData(userDict, merge: true) { err in
                    if let err = err {
                        print("Error writing users info document for user: \(err)")
                    } else {
                        print("Document successfully written for user!")
                        self.performSegue(withIdentifier: "signInToPublishVC", sender: nil)
                    }
                }
            }
        }
    }
}
