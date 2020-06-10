//
//  MainCoordinator.swift
//  mvc-mvvm
//
//  Created by RandomMac on 9/6/20.
//  Copyright © 2020 RandomMac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol MainCoordinatorDelegate {
    func showHomeViewController()
}

class MainCoordinator: Coordinator {
  
    // MARK: - Properties
    let rootViewController: TodoViewController
    let storyboard = UIStoryboard(name: K.StoryboardID.Main, bundle: nil)
    var delegate: MainCoordinatorDelegate?
    let disposeBag = DisposeBag()

    // MARK: VM / VC's
    lazy var todoViewModel: TodoViewModel! = {
        let viewModel = TodoViewModel(dataService: DataService())
        return viewModel
    }()
    
    lazy var profileViewModel: ProfileViewModel! = {
        let viewModel = ProfileViewModel(authService: AuthenticationService(), dataService: DataService())
        viewModel
        .onShowHomeViewController
            .subscribe(onNext: { [weak self] in
                self?.delegate?.showHomeViewController()
            }).disposed(by: disposeBag)
        return viewModel
    }()

    init(rootViewController: TodoViewController) {
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

extension MainCoordinator: TodoViewControllerDelegate {
    
    func showAddTodoViewController() {
        if let vc = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.AddTodoViewController) as? AddTodoViewController {
            vc.viewModel = todoViewModel
            rootViewController.navigationController?.show(vc, sender: nil)
        }
    }
    
    func showProfileViewController() {
        if let vc = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.ProfileViewController) as? ProfileViewController {
            vc.viewModel = profileViewModel
            rootViewController.navigationController?.show(vc, sender: nil)
        }
    }
    
    func showTodoDetailsViewController(cellViewModel: TodoCellViewModel) {
        if let vc = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.TodoDetailsViewController) as? TodoDetailsViewController {
            vc.viewModel = todoViewModel
            vc.todoCellViewModel = cellViewModel
            rootViewController.navigationController?.show(vc, sender: nil)
        }
    }
    
}
