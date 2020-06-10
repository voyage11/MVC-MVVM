//
//  HomeCoordinator.swift
//  mvc-mvvm
//
//  Created by RandomMac on 8/6/20.
//  Copyright © 2020 RandomMac. All rights reserved.
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
    let storyboard = UIStoryboard(name: K.StoryboardID.Home, bundle: nil)
    var delegate: HomeCoordinatorDelegate?
    let disposeBag = DisposeBag()

    // MARK: VM / VC's
    lazy var authViewModel: AuthViewModel! = {
        let viewModel = AuthViewModel(authService: AuthenticationService())
        viewModel
        .onShowTodoViewController
            .subscribe(onNext: { [weak self] in
                self?.delegate?.showTodoViewController()
            }).disposed(by: disposeBag)
        return viewModel
    }()

    init(rootViewController: HomeViewController) {
        self.rootViewController = rootViewController
    }

    override func start() {        
        rootViewController.delegate = self
    }
    
    override func finish() {
        //Clean up to prevent memory leak
        rootViewController.delegate = nil
    }
    
    deinit {
        //print("\(String(describing: type(of: self))) deinit")
    }
}


extension HomeCoordinator: HomeViewControllerDelegate {
    
    func showLoginViewController() {
        if let vc = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.LoginViewController) as? LoginViewController {
            vc.viewModel = authViewModel
            rootViewController.navigationController?.show(vc, sender: nil)
        }
    }
    
    func showSignUpViewController() {
        if let vc = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.SignUpViewController) as? SignUpViewController {
            vc.viewModel = authViewModel
            rootViewController.navigationController?.show(vc, sender: nil)
        }
    }
    
}
