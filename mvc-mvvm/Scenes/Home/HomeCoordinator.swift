//
//  HomeCoordinator.swift
//  mvc-mvvm
//
//  Created by Ricky on 8/6/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol HomeCoordinatorDelegate {
    func showTodoViewController()
}

class HomeCoordinator: Coordinator {
  
    // MARK: - Properties
    let rootViewController: HomeViewController
    let navigationController: UINavigationController
    let storyboard = UIStoryboard(name: K.StoryboardID.Home, bundle: nil)
    var delegate: HomeCoordinatorDelegate?
    let disposeBag = DisposeBag()

    // MARK: VM / VC's
    lazy var loginViewModel: LoginViewModel! = {
        let viewModel = LoginViewModel(authService: AuthenticationService())
        viewModel
        .onNextNavigation
            .subscribe(onNext: { [weak self] in
                self?.delegate?.showTodoViewController()
            }).disposed(by: disposeBag)
        return viewModel
    }()

    lazy var signUpViewModel: SignUpViewModel! = {
        let viewModel = SignUpViewModel(authService: AuthenticationService())
        viewModel
        .onNextNavigation
            .subscribe(onNext: { [weak self] in
                self?.delegate?.showTodoViewController()
            }).disposed(by: disposeBag)
        return viewModel
    }()
    
    init(rootViewController: HomeViewController, navigationController: UINavigationController) {
        self.rootViewController = rootViewController
        self.navigationController = navigationController
    }

    override func start() {        
        rootViewController.delegate = self
    }
    
    override func finish() {
        //Clean up to prevent memory leak
        rootViewController.delegate = nil
    }
    
    deinit {
        if K.showPrint {
            print("\(String(describing: type(of: self))) deinit")
        }
    }
}


extension HomeCoordinator: HomeViewControllerDelegate {
    
    func showLoginViewController() {
        if let vc = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.LoginViewController) as? LoginViewController {
            vc.viewModel = loginViewModel
            navigationController.show(vc, sender: nil)
        }
    }
    
    func showSignUpViewController() {
        if let vc = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.SignUpViewController) as? SignUpViewController {
            vc.viewModel = signUpViewModel
            navigationController.show(vc, sender: nil)
        }
    }
    
}
