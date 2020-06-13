//
//  TODODetailsViewController.swift
//  mvc-mvvm
//
//  Created by Ricky on 25/5/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import UIKit
import RxSwift

protocol TodoDetailsViewControllerDelegate {
    func popViewController()
}

class TodoDetailsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var delegate: TodoDetailsViewControllerDelegate?
    var viewModel: TodoDetailsViewModel?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let viewModel = viewModel {
            self.title = viewModel.todoCellViewModel.title
            titleLabel.text = viewModel.todoCellViewModel.title
            descriptionLabel.text = viewModel.todoCellViewModel.description
            dateLabel.text = viewModel.todoCellViewModel.dateString()
        }
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
                    self?.delegate?.popViewController()
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
    
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        guard let viewModel = viewModel,
            let id = viewModel.todoCellViewModel.id else {
            return
        }
        viewModel.deleteTodoItem(id: id)
    }

    deinit {
        if K.showPrint {
            print("\(String(describing: type(of: self))) deinit")
        }
    }
    
}
