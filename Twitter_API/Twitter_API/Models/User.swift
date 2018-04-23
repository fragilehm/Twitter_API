//
//  User.swift
//  Twitter_API
//
//  Created by Khasanza on 4/23/18.
//  Copyright © 2018 Khasanza. All rights reserved.
//

import SwiftyJSON

struct User {
    var profile_image_url: String
    var name: String
    var screen_name: String
    init(json: JSON) {
        profile_image_url = json["profile_image_url"].stringValue
        name = json["name"].stringValue
        screen_name = json["screen_name"].stringValue
    }
}
