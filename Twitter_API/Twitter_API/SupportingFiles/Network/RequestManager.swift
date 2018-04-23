//
//  RequestManager.swift
//  Twitter_API
//
//  Created by Khasanza on 4/23/18.
//  Copyright © 2018 Khasanza. All rights reserved.
//

import Foundation
import SystemConfiguration
import TwitterKit
import SwiftyJSON
class RequestManager {
    private var host = "https://api.twitter.com/1.1/"
    typealias SuccessHandler = (JSON?) -> Void
    typealias FailureHandler = (String)-> Void
    typealias Parameter = [String: Any]?
    private func request(method: HTTPMethod, endpoint: String, parameters: Parameter, complition: @escaping SuccessHandler, error: @escaping FailureHandler) {
        let apiURL = host + endpoint
        print(apiURL)
        print(method.rawValue)
        if !isConnectedToNetwork() {
            error(Constants.Network.ErrorMessages.NO_INTERNET_CONNECTION)
            return
        }
        if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient(userID: userID)
            var clientError : NSError?
            let request = client.urlRequest(withMethod: method.rawValue, urlString: apiURL, parameters: parameters, error: &clientError)
            
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                guard connectionError == nil else {
                    error(Constants.Network.ErrorMessages.CONNECTION_ERROR)
                    return
                }
                do {
                    let json = try JSON.init(data: data!)
                    complition(json)
                } catch let jsonError as NSError {
                    error(Constants.Network.ErrorMessages.FAILED_TO_PARSE_JSON)
                    print(jsonError)
                }
            }
            
        }
        
    }
    
    func post(endpoint: String, parameters: Parameter, completion: @escaping SuccessHandler, error: @escaping FailureHandler) {
        
    }
    func get(endpoint: String, parameters: Parameter, completion: @escaping SuccessHandler, error: @escaping FailureHandler) {
        request(method: .get, endpoint: endpoint, parameters: parameters, complition: completion, error: error)
    }
    
    private func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
}
