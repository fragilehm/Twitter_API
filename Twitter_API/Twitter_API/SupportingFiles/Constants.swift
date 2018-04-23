//
//  Constants.swift
//  Twitter_API
//
//  Created by Khasanza on 4/22/18.
//  Copyright © 2018 Khasanza. All rights reserved.
//

import UIKit
public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}
struct Constants {
    struct Network {
        struct Endpoints {
            static let getTweets = "statuses/user_timeline.json"
            static let getUser = "users/show.json"
        }
        struct ErrorMessages {
            static let NO_INTERNET_CONNECTION = "Please, connect to the internet and retry"
            static let FAILED_TO_PARSE_JSON = "Failed to get data, try later"
            static let CONNECTION_ERROR = "Connection Failed"
        }
    }
    struct Storyboard {
        static let MAIN_STORYBOARD = UIStoryboard(name: "Main", bundle: nil)
        static let PROFILE_STORYBOARD = UIStoryboard(name: "Profile", bundle: nil)
        static let LOGIN_STORYBOARD = UIStoryboard(name: "Login", bundle: nil)
    }
    struct ControllerId {
        static let MAIN_CONTROLLER = "MainViewController"
        static let MAIN_NAVIGATION_CONTROLLER = "MainNav"
        static let LOGIN_NAVIGATION_CONTROLLER = "LoginNav"
        static let LOGIN_CONTROLLER = "LoginViewController"
        static let PROFILE_CONTROLLER = "ProfileViewController"
    }
    struct CellId {
        static let TWEET_TABLE_VIEW_CELL = "TweetTableViewCell"
        static let PROFILE_HEADER_TABLE_VIEW_CELL = "HeaderTableViewCell"
        static let PROFILE_BODY_TABLE_VIEW_CELL = "BodyTableViewCell"
    }
    static let PROFILE_TITLES = ["", "About me", "Contacts", ""]
}
struct Colors {
    static let MAIN_COLOR = 0x00aced
}
