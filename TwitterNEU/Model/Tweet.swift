//
//  Tweet.swift
//  TwitterNEU
//
//  Created by Ashish Ashish on 11/14/19.
//  Copyright © 2019 Ashish. All rights reserved.
//

import Foundation

class Tweet{
    var author : String = ""
    var body : String = ""
    var uid : String = ""
    var key : String = ""
    
    init(author: String, body: String, uid: String, key: String) {
        self.author = author
        self.body = body
        self.uid = uid
        self.key = key
    }
}
