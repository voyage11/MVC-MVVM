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
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        fieldValidation()
    }
    
    func fieldValidation() {
        if emailTextField.text == "" {
            showMessage(title: "Email Required", message: "Please enter your email.", alertType: .error)
            emailTextField.becomeFirstResponder()
        } else if passwordTextField.text == "" {
            showMessage(title: "Password Required", message: "Please enter your password.",alertType: .error)
            passwordTextField.becomeFirstResponder()
        } else {
            let autheticationModel = Authentication(email: emailTextField.text!, password: passwordTextField.text!)
            let authenticationService = AuthenticationService()
            authenticationService.login(authentication: autheticationModel) { [weak self] error in
                if let e = error {
                    self?.showMessage(title: "Error", message: e, alertType: .error)
                } else {
                    self?.showMessage(title: "Success", message: "Welcome Back!", alertType: .success)
                    self?.moveToTODOViewController() 
                }
            }
        }
    }
    
    deinit {
        //print("\(String(describing: type(of: self))) deinit")
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            fieldValidation()
        }
        return false
    }
    
}
