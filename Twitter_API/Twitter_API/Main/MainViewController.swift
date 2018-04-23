//
//  MainViewController.swift
//  Twitter_API
//
//  Created by Khasanza on 4/22/18.
//  Copyright © 2018 Khasanza. All rights reserved.
//

import UIKit
import TwitterKit
import SwiftyJSON
import Kingfisher
import AVFoundation
import MediaPlayer
import AVKit
import MobileCoreServices
class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var tweets: Tweets?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        addTweetButton()
        addProfileButton()
        self.navigationItem.title = "Home"
        loadTweets()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //compose()
    }
    private func addTweetButton() {
        let button = UIButton.init(type: .system)
        button.setImage(#imageLiteral(resourceName: "tweet").withRenderingMode(.alwaysOriginal), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(tweet(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    private func addProfileButton() {
        let button = UIButton.init(type: .system)
        button.setImage(#imageLiteral(resourceName: "placeholder").withRenderingMode(.alwaysOriginal), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(showProfile(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    @objc private func showProfile(_ sender: UIButton) {
        print("profile")
        let profileVC = Constants.Storyboard.PROFILE_STORYBOARD.instantiateViewController(withIdentifier: Constants.ControllerId.PROFILE_CONTROLLER)
        self.navigationController?.show(profileVC, sender: self)
    }
    @objc private func tweet(_ sender: UIButton) {
        compose()
    }
    private func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
        self.tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        self.tableView.register(UINib.init(nibName: Constants.CellId.TWEET_TABLE_VIEW_CELL, bundle: nil), forCellReuseIdentifier: Constants.CellId.TWEET_TABLE_VIEW_CELL)
    }
    func compose() {
        if (TWTRTwitter.sharedInstance().sessionStore.hasLoggedInUsers()) {
            presentImagePicker()
        } else {
            TWTRTwitter.sharedInstance().logIn { session, error in
                if session != nil { // Log in succeeded
                    self.presentImagePicker()
                } else {
                    self.showErrorAlert(msg: "You must log in before presenting a composer.")
                }
            }
        }
    }
    func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.mediaTypes = [String(kUTTypeImage), String(kUTTypeMovie)]
        present(picker, animated: true, completion: nil)
    }
    
    func loadTweets() {
        let sessions = TWTRTwitter.sharedInstance().sessionStore.existingUserSessions()
        if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
            ServerManager.shared.getTweetsOfUser(user_id: userID, setTweets, error: showErrorAlert)
        }
    }
    func setTweets(tweets: Tweets) {
        self.tweets = tweets
        print(tweets.tweets[0])
        self.tableView.reloadData()
    }
}
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tweets = self.tweets else {
            return 0
        }
        return tweets.tweets.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellId.TWEET_TABLE_VIEW_CELL, for: indexPath) as! TweetTableViewCell
        cell.playDelegate = self
        cell.setData(tweet: (tweets?.tweets[indexPath.row])!)
        return cell
    }
}
extension MainViewController: UIImagePickerControllerDelegate, TWTRComposerViewControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: false, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Dismiss the image picker
        dismiss(animated: true, completion: nil)
        
        // Grab the relevant data from the image picker info dictionary
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let fileURL = info[UIImagePickerControllerMediaURL] as? URL
        
        // Create the composer
        let composer = TWTRComposerViewController(initialText: "", image: image, videoURL:fileURL)
        composer.delegate = self
        present(composer, animated: true, completion: nil)
    }
    func composerDidCancel(_ controller: TWTRComposerViewController) {
        self.dismiss(animated: false, completion: nil)
    }
    func composerDidSucceed(_ controller: TWTRComposerViewController, with tweet: TWTRTweet) {
        self.loadTweets()
    }
}
extension MainViewController: PlayVideoDelegate {
    func play(url: String) {
        //print("whaaaaaat", url)
        let player = AVPlayer(url: URL.init(string: url)!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true)
        {
            playerViewController.player!.play()
        }
    }
    
    
}
