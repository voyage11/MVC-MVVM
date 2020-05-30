//
//  TODODetailsViewController.swift
//  mvc1
//
//  Created by RandomMac on 25/5/20.
//  Copyright © 2020 RandomMac. All rights reserved.
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
