//
//  Extensions.swift
//  Twitter_API
//
//  Created by Khasanza on 4/22/18.
//  Copyright © 2018 Khasanza. All rights reserved.
//

import UIKit
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
extension UIViewController {
    func showErrorAlert(msg: String) {
        let alert = UIAlertController(title: "OOPS", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
extension String {
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MMM d HH:mm:ss Z yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GTM+6:00")
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "d MMM"
        dateFormatter.locale = Locale(identifier: "en_US")
        if let date = date {
            return dateFormatter.string(from: date)
        }

        return ""
    }
}

