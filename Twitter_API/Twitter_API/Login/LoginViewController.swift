//
//  LoginViewController.swift
//  Twitter_API
//
//  Created by Khasanza on 4/22/18.
//  Copyright © 2018 Khasanza. All rights reserved.
//

import UIKit
import TwitterKit
class LoginViewController: UIViewController {

    //@IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var twitterLogoImageView: UIImageView!
    var loginButton: TWTRLogInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        login()
        self.navigationItem.title = "Authorization"
    }
    private func login() {
        loginButton = TWTRLogInButton(logInCompletion: setTwtrSession)
        setupLoginButton()
    }
    private func setTwtrSession(twtrSession: TWTRSession?, error: Error?) {
        guard let session = twtrSession else {
            print("Failed to login via Twitter")
            return
        }
        let client = TWTRAPIClient()
        client.loadUser(withID: session.userID) { (user, error) in
            self.navigateToMain()
        }
    }
    private func navigateToMain() {
        let mainVC = Constants.Storyboard.MAIN_STORYBOARD.instantiateViewController(withIdentifier: Constants.ControllerId.MAIN_CONTROLLER)
        self.navigationController?.show(mainVC, sender: self)
    }
    private func setupLoginButton() {
        self.view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: twitterLogoImageView.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
}
