//
//  FollowUnfollowTableViewController.swift
//  TwitterNEU
//
//  Created by Ashish Ashish on 11/14/19.
//  Copyright © 2019 Ashish. All rights reserved.
//

import UIKit

import FirebaseAuth
import FirebaseDatabase

class FollowUnfollowTableViewController: UITableViewController {

    
    @IBOutlet var table: UITableView!
    
    var tappedUser : UserClass?
    
    var list = [String]()
    var listUsers = [UserClass]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUsers()
    }
    
    func loadUsers(){
        
        NEUTwitterAPI .shared().getUsers { (users:[UserClass]?) in
            self.listUsers = users!
            self.table.reloadData()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        tappedUser = listUsers[indexPath.row]
        performSegue(withIdentifier: "followMeSegue", sender: self)
    
    }

 

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listUsers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = "\(listUsers[indexPath.row].fullName) (\(listUsers[indexPath.row].email))"

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is FollowMeViewController
        {
            let vc = segue.destination as? FollowMeViewController
            vc?.userToFollow = tappedUser
        }
    }
    
    

}
