//
//  ProfileViewController.swift
//  mvc1
//
//  Created by RandomMac on 25/5/20.
//  Copyright © 2020 RandomMac. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ProfileViewController: UIViewController {

    @IBOutlet weak var uidTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        let user = User()
        uidTextField.text = user.uid
        emailTextField.text = user.email
        nameTextField.text = user.name
        nameTextField.delegate = self
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        let autheticationService = AuthenticationService()
        autheticationService.logout { [weak self] error in
            if let e = error {
                let alertMessage = AlertMessage(title: "Error", message:e, alertType: .error)
                self?.showMessage(alertMessage: alertMessage)
            } else {
                self?.moveToInitialViewController()
            }
        }
    }
    
    @IBAction func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        saveProfile()
    }
    
    func saveProfile() {
        if let name = nameTextField.text {
            let dateService = DataService()
            dateService.saveProfile(name: name) { [weak self] error in
                if let e = error {
                    let alertMessage = AlertMessage(title: "Error", message:e, alertType: .error)
                    self?.showMessage(alertMessage: alertMessage)
                } else {
                    let alertMessage = AlertMessage(title: "Success", message:"Name is saved successfully.", alertType: .success)
                    self?.showMessage(alertMessage: alertMessage)
                    DispatchQueue.main.async {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }

    deinit {
        //print("\(String(describing: type(of: self))) deinit")
    }
    
}


extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveProfile()
        return false
    }
    
}
