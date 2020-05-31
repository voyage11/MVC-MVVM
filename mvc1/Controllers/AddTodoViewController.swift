//
//  AddTODOViewController.swift
//  mvc1
//
//  Created by RandomMac on 25/5/20.
//  Copyright © 2020 RandomMac. All rights reserved.
//

import UIKit
import RxSwift

class AddTodoViewController: UIViewController {

    @IBOutlet weak var todoTitleTextField: UITextField!
    @IBOutlet weak var todoDescriptionTextView: UITextView!
    
    let viewModel = TodoViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add a TODO Item"
        todoTitleTextField.delegate = self
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
    
    
    @IBAction func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        saveTodoItem()
    }
    
    func saveTodoItem() {
        let user = User()
        let todoItem = TodoItem(title: todoTitleTextField.text!, description: todoDescriptionTextView.text!, date: Date().timeIntervalSince1970, uid: user.uid!, id: nil)
        viewModel.addTodoItem(todoItem: todoItem)
    }
    
    deinit {
        //print("\(String(describing: type(of: self))) deinit")
    }
    
}

extension AddTodoViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        todoDescriptionTextView.becomeFirstResponder()
        return false
    }
    
}
