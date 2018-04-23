//
//  Tweet.swift
//  Twitter_API
//
//  Created by Khasanza on 4/23/18.
//  Copyright © 2018 Khasanza. All rights reserved.
//

import UIKit
import SwiftyJSON
struct Tweets {
    var tweets = [Tweet]()
    init(json: JSON) {
        for js in json.array! {
            tweets.append(Tweet(json: js))
        }
    }
}
struct Tweet {
    var created_at: String
    var text: String
    var id_str: String
    var entities: Entities?
    var favorite_count: Int
    var retweet_count: Int
    var favorited: Bool
    var extended_entities: ExtendedEntities?
    var user: User
    init(json: JSON) {
        user = User(json: json["user"])
        favorited = json["favorited"].boolValue
        favorite_count = json["favorite_count"].intValue
        retweet_count = json["retweet_count"].intValue
        created_at = json["created_at"].stringValue
        text = json["text"].stringValue
        id_str = json["id_str"].stringValue
        entities = Entities(json: json["entities"])
        extended_entities = ExtendedEntities(json: json["extended_entities"])
    }
}

