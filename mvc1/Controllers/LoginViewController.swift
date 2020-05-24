//
//  LoginViewController.swift
//  mvc1
//
//  Created by RandomMac on 24/5/20.
//  Copyright © 2020 RandomMac. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if emailTextField.text == "" {
            showMessage(title: "Email Required", message: "Please enter your email.", errorBool: true, successBool: false)
        } else if emailTextField.text == nil || emailTextField.text == "" {
            showMessage(title: "Password Required", message: "Please enter your password.", errorBool: true, successBool: false)
        } else {
            let autheticationModel = Authentication(email: emailTextField.text!, password: passwordTextField.text!)
            let authenticationService = AuthenticationService()
            authenticationService.login(authentication: autheticationModel) { [weak self] error in
                if let e = error {
                    self?.showMessage(title: "Error", message: e, errorBool: true, successBool: false)
                } else {
                    self?.showMessage(title: "Success", message: "Welcome Back!", errorBool: false, successBool: true)
                    self?.performSegue(withIdentifier: "showContentViewController", sender: self)
                }
            }
        }
    }
    
}
