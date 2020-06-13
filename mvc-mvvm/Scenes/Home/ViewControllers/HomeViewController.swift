//
//  HomeViewController.swift
//  mvc-mvvm
//
//  Created by Ricky on 24/5/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import UIKit

protocol HomeViewControllerDelegate {
    func showLoginViewController()
    func showSignUpViewController()
}

class HomeViewController: UIViewController {

    var delegate: HomeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        delegate?.showLoginViewController()
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        delegate?.showSignUpViewController()
    }
    
    deinit {
        if K.showPrint {
            print("\(String(describing: type(of: self))) deinit")
        }
    }
    
}
