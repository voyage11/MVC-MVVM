//
//  ProfileViewController.swift
//  mvc-mvvm
//
//  Created by Ricky on 25/5/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import RxSwift

class ProfileViewController: UIViewController {

    @IBOutlet weak var uidTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!

    let viewModel = TodoViewModel()
    let authViewModel = AuthViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        let user = User()
        uidTextField.text = user.uid
        emailTextField.text = user.email
        nameTextField.text = user.name
        nameTextField.delegate = self
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel
            .onShowMessage
            .map { [weak self] alertMessage in
                self?.showMessage(alertMessage: alertMessage)
        }
        .subscribe()
        .disposed(by: disposeBag)
        
        viewModel
            .onNextNavigation
            .subscribe(onNext: { [weak self] in
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
            }).disposed(by: disposeBag)
        
        authViewModel
            .onShowMessage
            .map { [weak self] alertMessage in
                self?.showMessage(alertMessage: alertMessage)
        }
        .subscribe()
        .disposed(by: disposeBag)
        
        authViewModel
            .onNextNavigation
            .subscribe(onNext: { [weak self] in
                DispatchQueue.main.async {
                    self?.moveToInitialViewController()
                }
            }).disposed(by: disposeBag)
        
        viewModel
            .onShowLoading
            .subscribe(onNext: { [weak self] isLoading in
                if(isLoading) {
                    self?.startAnimating()
                } else {
                    self?.stopAnimating()
                }
            }).disposed(by: disposeBag)
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        authViewModel.logout()
    }
    
    @IBAction func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        saveProfile()
    }
    
    func saveProfile() {
        if let name = nameTextField.text {
            viewModel.saveProfile(name: name)
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
