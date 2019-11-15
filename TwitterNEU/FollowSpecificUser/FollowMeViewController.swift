//
//  FollowMeViewController.swift
//  TwitterNEU
//
//  Created by Ashish Ashish on 11/14/19.
//  Copyright © 2019 Ashish. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class FollowMeViewController: UIViewController {
    
    

    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var imageUser: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblEMail: UILabel!
    var loggedInuser : User?
        var ref : DatabaseReference?
        var refUser : DatabaseReference?
        var userToFollow : UserClass?
        override func viewDidLoad() {
            super.viewDidLoad()
            loggedInuser = Auth.auth().currentUser
            guard let  uid = loggedInuser?.uid else {return}
            ref = Database.database().reference().child("following").child(uid)
            

            // Do any additional setup after loading the view.
        }
        
        override func viewDidAppear(_ animated: Bool) {
            loadUser()
        }
        func loadUser(){
            lblName.text = "Name: \(userToFollow?.fullName ?? "Name: " )"
            lblEMail.text = "Name: \(userToFollow?.email ?? "Name: ")"
            
            if loggedInuser?.uid == userToFollow?.uid {
                followButton.isEnabled = false
                return
            }
            
            ref?.observeSingleEvent(of: .value, with: { (snapShot) in
                // print(snapShot)
                if let snapDict = snapShot.value as? [String:AnyObject]{
                    for each in snapDict as [String:AnyObject]{
                        let uidToFollow = each.value["uid"]! as! String
                        
                        let dateTime = each.value["dateTime"]! as! TimeInterval
                        print(NSDate(timeIntervalSince1970: dateTime/1000))
                        if uidToFollow == self.userToFollow?.uid {
                            self.followButton.titleLabel?.text = "Unfollow"
                            self.refUser = (self.ref?.child(each.key))!
                            return
                        }
                        
                    }
                }
            })
        }
        
    
    
    @IBAction func followMe(_ sender: Any) {
     if followButton.titleLabel?.text == "Follow" {

         let userVal =   ["uid": userToFollow?.uid,
                          "dateTime": ServerValue.timestamp()
         ] as [String : Any]
         
         followButton.titleLabel?.text = "Unfollow"
         ref!.childByAutoId().setValue(userVal)
         self.navigationController?.popViewController(animated: true)
         
     }else{
         
         refUser?.removeValue()
         followButton.titleLabel?.text = "Follow"
         self.navigationController?.popViewController(animated: true)
         
     }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
