//
//  RegisterViewController.swift
//  TwitterNEU
//
//  Created by Ashish on 11/7/19.
//  Copyright © 2019 Ashish. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtReenter: UITextField!
    @IBOutlet weak var lblWelcome: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    @IBAction func registerUser(_ sender: Any) {
        
        let email = txtEmail.text!
        let password = txtPassword.text!
        let fullName = txtName.text!
        let reenter = txtReenter.text!
        
        if !email.isEmail || email.isEmpty {
            lblWelcome.text = "Please enter valid e mail"
            return
        }
        if password.count < 6 {
            lblWelcome.text = "Password should be bigger than 6"
            return
        }
        if password != reenter{
            lblWelcome.text = "Passwords dont match"
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
          // [START_EXCLUDE]
         
            guard let user = authResult?.user, error == nil else {
                self.lblWelcome.text = error!.localizedDescription
              return
            }
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = fullName
            changeRequest?.commitChanges { (error) in
              print(error)
                self.addUserInDatabase(user: user)
            }
            
            
            
            print("\(user.email!) created")
            let alert = UIAlertController(title: "User Created", message: "", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            }))

            self.present(alert, animated: true)
        }
    }
    
    func addUserInDatabase(user : User){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let uid = user.uid
        
        let userDetail =    ["email": user.email,
                             "fullName": user.displayName
                            ]
        
        let userFollowed = [uid : uid]
        
        let post = ["uid": uid,
        "author": user.displayName,
        "body": "This is my First Tweet"] as [String : Any]
        
        
        ref.child("users").child(uid).setValue(userDetail)
        //ref.child("posts").child(uid).setValue(post)
        
        guard let key = ref.child("following").child(uid).childByAutoId().key else { return}
        let userVal =   ["uid": uid,
                         "dateTime": ServerValue.timestamp()
                        ] as [String : Any]

        let childUpdates = ["/following/\(uid)/\(key)/": userVal,
                            "/tweets/\(uid)/\(key)/": post
                            ]
        ref.updateChildValues(childUpdates)

    }
    

   

}
