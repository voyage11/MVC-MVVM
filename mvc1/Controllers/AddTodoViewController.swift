//
//  AddTODOViewController.swift
//  mvc1
//
//  Created by RandomMac on 25/5/20.
//  Copyright © 2020 RandomMac. All rights reserved.
//

import UIKit

class AddTodoViewController: UIViewController {

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
                self?.showMessage(title: "Error", message: e, alertType: .error)
            } else {
                self?.showMessage(title: "Success", message: "The TODO item is added.", alertType: .success)
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
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
