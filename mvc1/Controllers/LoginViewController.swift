//
//  LoginViewController.swift
//  mvc1
//
//  Created by RandomMac on 24/5/20.
//  Copyright © 2020 RandomMac. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import RxSwift
import RxCocoa
import RxSwiftExt
import NVActivityIndicatorView

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    
    let viewModel = AuthViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
        emailTextField.delegate = self
        passwordTextField.delegate = self
        bindViewModel()
    }
    
    private func bind(textField: UITextField, to behaviorRelay: BehaviorRelay<String>) {
        behaviorRelay.asObservable()
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
        textField.rx.text.unwrap()
            .bind(to: behaviorRelay)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        bind(textField: emailTextField, to: viewModel.email)
        bind(textField: passwordTextField, to: viewModel.password)
        
        viewModel
            .onShowMessage
            .map { [weak self] alertMessage in
                self?.showMessage(alertMessage: alertMessage)
                DispatchQueue.main.async {
                    if(alertMessage.title == "Email Required") {
                        self?.emailTextField.becomeFirstResponder()
                    } else if(alertMessage.title == "Password Required") {
                        self?.passwordTextField.becomeFirstResponder()
                    }
                }
            }
            .subscribe()
            .disposed(by: disposeBag)
            
        viewModel
        .onNextNavigation
            .subscribe(onNext: { [weak self] in
                self?.moveToTODOViewController()
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
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        viewModel.login()
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
            viewModel.login()
        }
        return false
    }
    
}
