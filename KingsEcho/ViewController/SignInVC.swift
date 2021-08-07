//
//  SignInVC.swift
//  KingsEcho
//
//  Created by Radiance Okuzor on 8/4/21.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
          
    }
    
    override func viewDidLayoutSubviews() {
        if let authUser = Auth.auth().currentUser {
            self.performSegue(withIdentifier: "signInToPublishVC", sender: nil)
//            try! Auth.auth().signOut()
        }
    }

    @IBAction func signIn(_ sender:UIButton){
        Auth.auth().signIn(withEmail: emailLabel.text!, password: passwordLabel.text!) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            
            strongSelf.performSegue(withIdentifier: "signInToPublishVC", sender: self)
          // ...
        }
    }
 
}
