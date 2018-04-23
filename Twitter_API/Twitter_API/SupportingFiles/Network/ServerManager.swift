//
//  ServerManager.swift
//  Twitter_API
//
//  Created by Khasanza on 4/23/18.
//  Copyright © 2018 Khasanza. All rights reserved.
//

import Foundation
import SwiftyJSON
class ServerManager: RequestManager {
    class var shared: ServerManager {
        struct Static {
            static let instance = ServerManager()
        }
        return Static.instance
    }
    func getTweetsOfUser(user_id: String, _ completion: @escaping (Tweets)-> Void, error: @escaping (String)-> Void) {
        let parameters = ["user_id": user_id]
        self.get(endpoint: Constants.Network.Endpoints.getTweets, parameters: parameters, completion: { (json) in
            let tweets = Tweets(json: json!)
            completion(tweets)
        }, error: error)
    }
}
