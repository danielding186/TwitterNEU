//
//  MyTweetsTableViewController.swift
//  TwitterNEU
//
//  Created by Ashish on 11/7/19.
//  Copyright © 2019 Ashish. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class MyTweetsTableViewController: UITableViewController {

    var arr = [String]()
    
    @IBOutlet var table: UITableView!
    
    var user : User?
    var ref : DatabaseReference?
    override func viewDidLoad() {
        super.viewDidLoad()
        user = Auth.auth().currentUser
        
        guard let  uid = user?.uid else {return}
        
        ref = Database.database().reference().child("tweets").child(uid)
        
        loadPosts()
    }
    
    
    func loadPosts(){
        ref?.observeSingleEvent(of: .value, with: { (snapShot) in
            
           // print(snapShot)
            if let snapDict = snapShot.value as? [String:AnyObject]{

                for each in snapDict as [String:AnyObject]{
                    let tweet = each.value["body"] as! String
                    print(tweet)
                    self.arr.append(tweet)
                }
                self.table.reloadData()
                //self.getPosts()
            }
        })
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = arr[indexPath.row]

        return cell
    }
    

}
