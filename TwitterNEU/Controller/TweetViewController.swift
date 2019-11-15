//
//  TweetViewController.swift
//  TwitterNEU
//
//  Created by Ashish on 11/7/19.
//  Copyright © 2019 Ashish. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class TweetViewController: UIViewController , UITextViewDelegate{

    @IBOutlet weak var txtTweet: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTweet.text = "Placeholder for UITextView"
        txtTweet.textColor = UIColor.lightGray
        txtTweet.font = UIFont(name: "verdana", size: 13.0)
        txtTweet.returnKeyType = .done
        txtTweet.delegate = self
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tweet(_ sender: Any) {
        // create Post
        let ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let fullName = Auth.auth().currentUser?.displayName else {return}
     
               
        guard let key = ref.child("tweets").child(uid).childByAutoId().key else { return }
        let post = ["uid": uid,
                    "author": fullName,
                    "body": txtTweet.text] as [String : Any]
             
               
        let childUpdates = ["/tweets/\(uid)/\(key)": post]
        ref.updateChildValues(childUpdates)
        self.navigationController?.popViewController(animated: true)
    }
    
   func textViewDidBeginEditing (_ textView: UITextView) {
        if txtTweet.text == "Placeholder for UITextView" {
            txtTweet.text = ""
            txtTweet.textColor = UIColor.black
            txtTweet.font = UIFont(name: "verdana", size: 18.0)
        }
    }
}
