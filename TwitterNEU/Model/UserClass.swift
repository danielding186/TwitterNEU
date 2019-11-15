//
//  UserClass.swift
//  TwitterNEU
//
//  Created by Ashish Ashish on 11/14/19.
//  Copyright © 2019 Ashish. All rights reserved.
//

import Foundation

class UserClass{
    var uid : String = ""
    var email : String = ""
    var fullName : String = ""
    
    init(uid: String, email: String, fullName: String){
        self.uid = uid
        self.email = email
        self.fullName = fullName
    }
    
    
}
