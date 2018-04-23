//
//  BodyTableViewCell.swift
//  Twitter_API
//
//  Created by Khasanza on 4/23/18.
//  Copyright © 2018 Khasanza. All rights reserved.
//

import UIKit
import TwitterKit
class BodyTableViewCell: UITableViewCell {

    @IBOutlet weak var contentTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setContent(user: User?, section: Int) {
        var text = "Logout"
        if let user = user {
            if section == 1 {
                if let description = user.description {
                    text = description + "\n" + user.url
                }
            } else if section == 2 {
                if let location = user.location {
                    text = location
                }
            } else {
                contentTextView.textAlignment = .center
            }
        }
        self.contentTextView.text = text
    }
    
}
