//
//  SignUpViewController.swift
//  mvc1
//
//  Created by RandomMac on 24/5/20.
//  Copyright © 2020 RandomMac. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftMessages

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Signup"
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        fieldValidation()
    }
    
    func fieldValidation() {
        if emailTextField.text == "" {
            showMessage(title: "Email Required", message: "Please enter your email.", alertType: .error)
            emailTextField.becomeFirstResponder()
        } else if passwordTextField.text == "" {
            showMessage(title: "Password Required", message: "Please enter your password.", alertType: .error)
            passwordTextField.becomeFirstResponder()
        } else {
            startAnimating()
            let autheticationModel = Authentication(email: emailTextField.text!, password: passwordTextField.text!)
            let authenticationService = AuthenticationService()
            authenticationService.signUp(authentication: autheticationModel) { [weak self] error in
                if let e = error {
                    self?.showMessage(title: "Error", message: e, alertType: .error)
                } else {
                    self?.showMessage(title: "Success", message: "Welcome Back!", alertType: .success)
                    self?.moveToTODOViewController()
                }
                self?.stopAnimating()
            }
        }
    }
    
    deinit {
        //print("\(String(describing: type(of: self))) deinit")
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            fieldValidation()
        }
        return false
    }
    
}
