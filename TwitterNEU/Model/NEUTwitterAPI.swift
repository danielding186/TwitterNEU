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
    private static let URL: String = "https://us-central1-neutwitter-9157a.cloudfunctions.net"
    
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
            else {
                completion(nil)
            }
        }
    }
    
    func getMyTweets(uid: String, completion:  @escaping ([Tweet]) -> Void) {
        let url:String = NEUTwitterAPI.URL + "/myTweets?uid=\(uid)"
        Alamofire.request(url).responseJSON {
            response in
            var tweets:[Tweet] = []
            if response.result.isSuccess {
                let data:JSON = JSON(response.result.value!)

                for (key, item) in data {
                    let tweet:Tweet? = Tweet(
                        author: item["author"].rawString()!,
                        body: item["body"].rawString()!,
                        uid: uid, key: key)
                    if tweet != nil {
                        tweets.append(tweet!)
                    }
                }
                completion(tweets)
            }
            else {
                completion(tweets)
            }
        }
    }
    
    func postTweet(uid: String, author:String, body: String, completion: @escaping (Bool)->Void) {
        let url: String = NEUTwitterAPI.URL + "/addTweet"
        let params: [String: Any] = [
            "uid": uid,
            "author": author,
            "body": body
        ]
        Alamofire.request(url, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            if response.result.isSuccess {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    
    func follow(uid: String, follower: String, completion: @escaping (String?)->Void) {
        let url: String = NEUTwitterAPI.URL + "/follow"
        let params: [String: Any] = [
            "uid": uid,
            "followerId": follower
        ]
        Alamofire.request(url, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            if response.result.isSuccess {
                let data:JSON = JSON(response.result.value!)
                completion(data["relationID"].rawString())
            } else {
                completion(nil)
            }
        }
    }
    
    func unfollow(uid: String, relationID: String, completion: @escaping (Bool)->Void) {
        let url: String = NEUTwitterAPI.URL + "/unfollow"
        let params: [String: Any] = [
            "uid": uid,
            "relationID": relationID,
        ]
        Alamofire.request(url, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: nil).response {
            response in
            if response.response?.statusCode == 200 {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func relationship(uid: String, followerID: String, completion: @escaping (Int?, String?)->Void) {
        let url: String = NEUTwitterAPI.URL + "/relationship?uid=\(uid)&followerId=\(followerID)"
        Alamofire.request(url).responseJSON {
            response in
            if response.result.isSuccess {
                let data:JSON = JSON(response.result.value!)
                completion(data["followed"].rawValue as? Int, data["relationID"].rawString())
            } else {
                completion(nil, nil)
            }
        }
    }
    
    
}
