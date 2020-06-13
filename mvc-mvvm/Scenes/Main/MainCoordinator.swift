//
//  MainCoordinator.swift
//  mvc-mvvm
//
//  Created by Ricky on 9/6/20.
//  Copyright © 2020 Ricky. All rights reserved.
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
    let navigationController: UINavigationController
    let storyboard = UIStoryboard(name: K.StoryboardID.Main, bundle: nil)
    var delegate: MainCoordinatorDelegate?
    let disposeBag = DisposeBag()

    // MARK: VM / VC's        
    lazy var profileViewModel: ProfileViewModel! = {
        let viewModel = ProfileViewModel(authService: AuthenticationService(), dataService: DataService())
        viewModel
        .onShowHomeViewController
            .subscribe(onNext: { [weak self] in
                self?.delegate?.showHomeViewController()
            }).disposed(by: disposeBag)
        return viewModel
    }()

    init(rootViewController: TodoViewController, navigationController: UINavigationController) {
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

extension MainCoordinator: TodoViewControllerDelegate {
    
    func showAddTodoViewController() {
        if let vc = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.AddTodoViewController) as? AddTodoViewController {
            vc.viewModel = AddTodoViewModel(dataService: DataService())
            vc.delegate = self
            navigationController.show(vc, sender: nil)
        }
    }
    
    func showProfileViewController() {
        if let vc = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.ProfileViewController) as? ProfileViewController {
            vc.viewModel = profileViewModel
            vc.delegate = self
            navigationController.show(vc, sender: nil)
        }
    }
    
    func showTodoDetailsViewController(_ todoCellViewModel: TodoCellViewModel) {
        if let vc = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.TodoDetailsViewController) as? TodoDetailsViewController {
            vc.viewModel = TodoDetailsViewModel(dataService: DataService(), todoCellViewModel: todoCellViewModel)
            vc.delegate = self
            navigationController.show(vc, sender: nil)
        }
    }
    
}


extension MainCoordinator: AddTodoViewControllerDelegate, ProfileViewControllerDelegate, TodoDetailsViewControllerDelegate {
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
}
