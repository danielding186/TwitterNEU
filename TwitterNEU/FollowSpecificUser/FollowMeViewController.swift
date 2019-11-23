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
    var userToFollow : UserClass?
    
    var uid: String = ""
    var followerId: String = ""
    var relationShipID: String?
    
    override func viewDidLoad() {
        
        loggedInuser = Auth.auth().currentUser
        guard let uid = loggedInuser?.uid else {return}
        guard let followerId = userToFollow?.uid else{return}
        self.uid = uid
        self.followerId = followerId
        loadUser()
        
    }
    

    func loadUser(){
        lblName.text = "Name: \(userToFollow?.fullName ?? "Name: " )"
        lblEMail.text = "Name: \(userToFollow?.email ?? "Name: ")"
        
        if loggedInuser?.uid == userToFollow?.uid {
            followButton.isEnabled = false
            return
        }
        
        self.followButton.setTitle("...", for: .normal)
        
        NEUTwitterAPI.shared().relationship(uid: uid, followerID: followerId) { (isFollowed: Int?, realtionId: String?) in
            if (isFollowed == 1) {
                self.followButton.setTitle("Unfollow", for: .normal)
                self.relationShipID = realtionId
            }
            else {
                self.followButton.setTitle("Follow", for: .normal)
            }
        }
    }
    
    
    
    @IBAction func followMe(_ sender: Any) {
        if followButton.titleLabel?.text == "..." {
            return
        }
        
        if followButton.titleLabel?.text == "Follow" {
            
            NEUTwitterAPI.shared().follow(uid: uid, follower: followerId) { (realtionId: String?) in
                self.relationShipID = realtionId
                self.followButton.setTitle("Unfollow", for: .normal)
            }
            
            self.followButton.setTitle("...", for: .normal)
        }else{
            
            if self.relationShipID == nil {
                self.followButton.setTitle("Follow", for: .normal)
                return;
            }
            
            NEUTwitterAPI.shared().unfollow(uid: uid, relationID: self.relationShipID!) { (result: Bool) in
                if result {
                    self.followButton.setTitle("Follow", for: .normal)
                    self.relationShipID = nil;
                } else {
                     self.followButton.setTitle("Unfollow", for: .normal)
                }
            }
            
            self.followButton.setTitle("...", for: .normal)
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
