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
    override func viewDidLoad() {
        super.viewDidLoad()
        user = Auth.auth().currentUser
        loadPosts()
    }
    
    
    func loadPosts(){
        guard let  uid = user?.uid else {return}
        NEUTwitterAPI.shared().getMyTweets(uid: uid) { (tweets:[Tweet]) in
            for tweet in tweets {
                self.arr.append(tweet.body)
            }
            self.table.reloadData()
        }
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
