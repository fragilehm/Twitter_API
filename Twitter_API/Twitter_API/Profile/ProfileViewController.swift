//
//  ProfileViewController.swift
//  Twitter_API
//
//  Created by Khasanza on 4/23/18.
//  Copyright © 2018 Khasanza. All rights reserved.
//

import UIKit
import TwitterKit
class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getUser()
        // Do any additional setup after loading the view.
    }
    private func getUser() {
        if let userID = TWTRTwitter.sharedInstance().sessionStore.session()?.userID {
            ServerManager.shared.getUserDetail(user_id: userID, { (user) in
                self.user = user
                self.tableView.reloadData()
            }, error: showErrorAlert)
//            let client = TWTRAPIClient()
//            client.loadUser(withID: userID) { (user, error) in
//                if let user = user {
//                    self.user = user
//                    self.tableView.reloadData()
//                } else {
//                    self.showErrorAlert(msg: "Failed to get user's data")
//                }
//            }
        }
    }
    private func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
        self.tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        self.tableView.register(UINib.init(nibName: Constants.CellId.PROFILE_HEADER_TABLE_VIEW_CELL, bundle: nil), forCellReuseIdentifier: Constants.CellId.PROFILE_HEADER_TABLE_VIEW_CELL)
        self.tableView.register(UINib.init(nibName: Constants.CellId.PROFILE_BODY_TABLE_VIEW_CELL, bundle: nil), forCellReuseIdentifier: Constants.CellId.PROFILE_BODY_TABLE_VIEW_CELL)
    }
}
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = user {
            return Constants.PROFILE_TITLES.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellId.PROFILE_HEADER_TABLE_VIEW_CELL, for: indexPath) as! HeaderTableViewCell
            if let user = self.user {
                cell.setHeader(user: user)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellId.PROFILE_BODY_TABLE_VIEW_CELL, for: indexPath) as! BodyTableViewCell
            cell.setContent(user: self.user, section: indexPath.section)
            return cell
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            let store = TWTRTwitter.sharedInstance().sessionStore
            if let userID = store.session()?.userID {
                store.logOutUserID(userID)
                let loginVC = Constants.Storyboard.LOGIN_STORYBOARD.instantiateViewController(withIdentifier: Constants.ControllerId.LOGIN_NAVIGATION_CONTROLLER)
                self.present(loginVC, animated: false, completion: nil)
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let space: CGFloat = section == 0 ? 0 : 20
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 30 + space)
        let label = UILabel(frame: CGRect(x: 16, y: 25 - space, width: self.tableView.bounds.width - 10, height: 20))
        view.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.text = Constants.PROFILE_TITLES[section]
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 30
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 20
    }
}
