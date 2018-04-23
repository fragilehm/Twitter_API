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
class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var tweets: Tweets?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.navigationItem.title = "Authorization"
        loadTweets()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //compose()
    }
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
        self.tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        self.tableView.register(UINib.init(nibName: Constants.CellId.TWEET_TABLE_VIEW_CELL, bundle: nil), forCellReuseIdentifier: Constants.CellId.TWEET_TABLE_VIEW_CELL)
    }
    func compose() {
        let composer = TWTRComposer()
        
        composer.setText("just setting up my Twitter Kit")
        composer.setImage(UIImage(named: "twitter"))
        composer.show(from: self) { (result) in
            if result == .done {
                print("done")
            } else {
                print("not done")
            }
        }
    }
    func loadTweets() {
        let sessions = TWTRTwitter.sharedInstance().sessionStore.existingUserSessions()
        print(sessions.count)
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
