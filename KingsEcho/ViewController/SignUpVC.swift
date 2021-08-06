//
//  SignUpVC.swift
//  KingsEcho
//
//  Created by Radiance Okuzor on 8/4/21.
//

import UIKit
import FirebaseAuth

class SignUpVC: UIViewController {
    
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
              let photoURL = user.photoURL
              var multiFactorString = "MultiFactor: "
              for info in user.multiFactor.enrolledFactors {
                multiFactorString += info.displayName ?? "[DispayName]"
                multiFactorString += " "
              }
              // ...
            }
        }
    }
}
