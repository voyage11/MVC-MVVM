//
//  AddTODOViewController.swift
//  mvc1
//
//  Created by RandomMac on 25/5/20.
//  Copyright © 2020 RandomMac. All rights reserved.
//

import UIKit

class AddTODOViewController: UIViewController {

    @IBOutlet weak var todoTitleTextField: UITextField!
    @IBOutlet weak var todoDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add a TODO Item"
        todoTitleTextField.delegate = self
    }
    
    @IBAction func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        saveTodoItem()
    }
    
    func saveTodoItem() {
        let dataService = DataService()
        let user = User()
        let todoItem = TodoItem(title: todoTitleTextField.text!, description: todoDescriptionTextView.text!, date: Date().timeIntervalSince1970, uid: user.uid!, id: nil)
        dataService.addTodoItem(todoItem: todoItem) { [weak self] error in
            if let e = error {
                self?.showMessage(title: "Error", message: e, errorBool: true, successBool: false)
            } else {
                self?.showMessage(title: "Success", message: "The TODO item is added.", errorBool: false, successBool: true)
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    deinit {
        print("AddTODOViewController deinit")
    }
    
}

extension AddTODOViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        todoDescriptionTextView.becomeFirstResponder()
        return false
    }
    
    
    
}
