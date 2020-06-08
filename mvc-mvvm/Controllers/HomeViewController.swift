//
//  HomeViewController.swift
//  mvc-mvvm
//
//  Created by Ricky on 24/5/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: K.StoryboardID.Main, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.LoginViewController) as? LoginViewController {
            vc.viewModel = AuthViewModel()
            show(vc, sender: self)
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: K.StoryboardID.Main, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.SignUpViewController) as? SignUpViewController {
            vc.viewModel = AuthViewModel()
            show(vc, sender: self)
        }
    }
    
    deinit {
        //print("\(String(describing: type(of: self))) deinit")
    }
    
}
