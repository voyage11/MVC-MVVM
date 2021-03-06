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

    var viewModel: ProfileViewModel?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel?.title
        let user = User()
        uidTextField.text = user.uid
        emailTextField.text = user.email
        nameTextField.text = user.name
        nameTextField.delegate = self
        bindViewModel()
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
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
        
        viewModel
            .onLogout
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
    
    private func saveProfile() {
        guard let viewModel = viewModel else { return }
        if let name = nameTextField.text {
            viewModel.saveProfile(name: name)
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        viewModel.logout()
    }
    
    @IBAction func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        saveProfile()
    }
    
    deinit {
        if K.showPrint {
            print("\(String(describing: type(of: self))) deinit")
        }
    }
    
}


extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveProfile()
        return false
    }
    
}
