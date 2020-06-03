//
//  TODODetailsViewController.swift
//  mvc-mvvm
//
//  Created by Ricky on 25/5/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import UIKit
import RxSwift

class TodoDetailsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var todoCellViewModel: TodoCellViewModel?
    let viewModel = TodoViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let todoCellViewModel = todoCellViewModel {
            self.title = todoCellViewModel.title
            titleLabel.text = todoCellViewModel.title
            descriptionLabel.text = todoCellViewModel.description
            dateLabel.text = todoCellViewModel.dateString()
        }
        bindViewModel()
    }
    
    private func bindViewModel() {
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
        guard let todoCellViewModel = todoCellViewModel, let id = todoCellViewModel.id else {
            return
        }
        viewModel.deleteTodoItem(id: id)
    }

    deinit {
        //print("\(String(describing: type(of: self))) deinit")
    }
    
}
