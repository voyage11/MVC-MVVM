//
//  AddTODOViewController.swift
//  mvc-mvvm
//
//  Created by Ricky on 25/5/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import UIKit
import RxSwift

class AddTodoViewController: UIViewController {

    @IBOutlet weak var todoTitleTextField: UITextField!
    @IBOutlet weak var todoDescriptionTextView: UITextView!
    
    var viewModel: AddTodoViewModel?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel?.title
        todoTitleTextField.delegate = self
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
    
    private func saveTodoItem() {
        guard let viewModel = viewModel else { return }
        let user = User()
        let todoItem = TodoItem(title: todoTitleTextField.text!, description: todoDescriptionTextView.text!, date: Date().timeIntervalSince1970, uid: user.uid!, id: nil)
        viewModel.addTodoItem(todoItem: todoItem)
    }
    
    @IBAction func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        saveTodoItem()
    }
    
    deinit {
        if K.showPrint {
            print("\(String(describing: type(of: self))) deinit")
        }
    }
    
}

extension AddTodoViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        todoDescriptionTextView.becomeFirstResponder()
        return false
    }
    
}
