//
//  LoginViewController.swift
//  mvc-mvvm
//
//  Created by Ricky on 24/5/20.
//  Copyright © 2020 Ricky. All rights reserved.
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
    
    var viewModel: LoginViewModel?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel?.title
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
        guard let viewModel = viewModel else { return }
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
            .onShowLoading
            .subscribe(onNext: { [weak self] isLoading in
                if(isLoading) {
                    self?.startAnimating()
                } else {
                    self?.stopAnimating()
                }
            }).disposed(by: disposeBag)
    }
    
    private func login() {
        if let viewModel = viewModel {
            viewModel.login()
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        login()
    }
    
    deinit {
        if K.showPrint {
            print("\(String(describing: type(of: self))) deinit")
        }
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            login()
        }
        return false
    }
    
}
