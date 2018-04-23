//
//  TweetTableViewCell.swift
//  Twitter_API
//
//  Created by Khasanza on 4/23/18.
//  Copyright © 2018 Khasanza. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import AVKit
protocol PlayVideoDelegate: class {
    func play(url: String)
}
class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userFullnameLabel: UILabel!
    @IBOutlet weak var userUsernameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var shareCountLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var tweetImageHeightConstraint: NSLayoutConstraint!
    private var video_url: String?
    weak var playDelegate: PlayVideoDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func playPressed(_ sender: Any) {
        if let url = video_url {
            if let delegate = playDelegate {
                delegate.play(url: url)
            }
        }
    }
    func setData(tweet: Tweet) {
        let profile_image_url = URL.init(string: tweet.user.profile_image_url)
        setImage(with: profile_image_url, imageView: profileImageView)
        if let entities = tweet.extended_entities, entities.media.medias.count > 0 {
            let media = entities.media.medias[0]
            let tweet_image_url = URL.init(string: media.media_url)
            self.setImage(with: tweet_image_url, imageView: tweetImageView)
            checkForVideo(media: media)
            tweetImageHeightConstraint.constant = 180
        } else {
            tweetImageHeightConstraint.constant = 0
            self.playButton.isHidden = true
            print("no images found")
            self.tweetImageView.image = UIImage.init(named: "placeholder")
        }
        userFullnameLabel.text = tweet.user.name
        userUsernameLabel.text = "@\(tweet.user.screen_name)"
        descriptionTextView.text = tweet.text
        favoriteCountLabel.text = "\(tweet.favorite_count)"
        retweetCountLabel.text = "\(tweet.retweet_count)"
        createdAtLabel.text = tweet.created_at.getFormattedDate()
        
    }
    private func checkForVideo(media: Media) {
        if media.type == "video" && (media.video_info?.variants.variants.count)! > 0 {
            self.playButton.isHidden = false
            self.video_url = media.video_info?.variants.variants[0].url
        } else {
            self.playButton.isHidden = true
        }
    }
    private func setImage(with url: URL?, imageView: UIImageView) {
        if let url = url {
           // imageView.kf.setImage(with: url, placeholder: UIImage.init(named: "placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
            imageView.kf.setImage(with: url)
        }
    }
}
