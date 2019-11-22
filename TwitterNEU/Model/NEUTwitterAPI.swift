//
//  NEUTwitterAPI.swift
//  TwitterNEU
//
//  Created by yanjingding on 11/22/19.
//  Copyright © 2019 Ashish. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NEUTwitterAPI: NSObject {
    private static let sharedManager = NEUTwitterAPI()
    private static let URL: String = "https://us-central1-neutwitter-9157a.cloudfunctions.net/users"
    
    private override init() {
        super.init()
    }
    
    class func shared() -> NEUTwitterAPI {
         return sharedManager
    }
    
    func getUsers(completion:  @escaping ([UserClass]?) -> Void) {
        let url:String = NEUTwitterAPI.URL + "/users"
        Alamofire.request(url).responseJSON {
                    response in
                    if response.result.isSuccess {
                        let data:JSON = JSON(response.result.value!)
                    
                    var users:[UserClass]? = []
                        
                    for (key, item) in data {
                        let uid = key
                        let user:UserClass? = UserClass(uid: uid, email: item["email"].rawString()!, fullName: item["fullName"].rawString()!)
                        if user != nil {
                            users?.append(user!)
                        }
                        
                    }
                    completion(users)
                }
        }
    }
    
}
