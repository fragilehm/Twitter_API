//
//  MainViewController.swift
//  Twitter_API
//
//  Created by Khasanza on 4/22/18.
//  Copyright © 2018 Khasanza. All rights reserved.
//
import Foundation
import UIKit
import TwitterKit
import SwiftyJSON
import Kingfisher
import AVFoundation
import MediaPlayer
import AVKit
import MobileCoreServices
import PullToRefreshKit
class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private weak var timer: Timer?
    private var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    private let loadingView: UIView = UIView()

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
        startTimer()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopTimer()
    }
    private func startTimer(){
        self.timer?.invalidate()
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { [weak self] _ in
                self?.showActivityIndicator()
                self?.loadTweets()
            })
        } else {
            // Fallback on earlier versions
        }
    }
    private func stopTimer() {
        self.timer?.invalidate()
    }
    private func showActivityIndicator() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = view.center
        loadingView.backgroundColor = UIColor().colorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        actInd.hidesWhenStopped = true
        loadingView.addSubview(actInd)
        view.addSubview(loadingView)
        actInd.startAnimating()
    }
    private func hideActivityIndicator() {
        UIApplication.shared.endIgnoringInteractionEvents()
        actInd.stopAnimating()
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
        configureRefreshHeader()
        
    }
    private func configureRefreshHeader() {
        let header = DefaultRefreshHeader.header()
        header.setText(Constants.Hint.Refresh.pull_to_refresh, mode: .pullToRefresh)
        header.setText(Constants.Hint.Refresh.relase_to_refresh, mode: .releaseToRefresh)
        header.setText(Constants.Hint.Refresh.success, mode: .refreshSuccess)
        header.setText(Constants.Hint.Refresh.refreshing, mode: .refreshing)
        header.setText(Constants.Hint.Refresh.failed, mode: .refreshFailure)
        header.imageRenderingWithTintColor = true
        header.durationWhenHide = 0.4
        self.tableView.configRefreshHeader(container: self) { [weak self] in
            self?.loadTweets()
        }
    }
    private func compose() {
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
        if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
            ServerManager.shared.getTweetsOfUser(user_id: userID, setTweets, error: showErrorAlert)
        }
    }
    func setTweets(tweets: Tweets) {
        self.loadingView.removeFromSuperview()
        self.tableView.switchRefreshHeader(to: .normal(.none, 0.0))
        self.tweets = tweets
        hideActivityIndicator()
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
        //self.dismiss(animated: false, completion: nil)
    }
    func composerDidSucceed(_ controller: TWTRComposerViewController, with tweet: TWTRTweet) {
        self.loadTweets()
    }
}
extension MainViewController: PlayVideoDelegate {
    func play(url: String) {
        let player = AVPlayer(url: URL.init(string: url)!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true)
        {
            playerViewController.player!.play()
        }
    }
    
    
}
