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
        self.title = "Add TODO Item"
    }
    
    @IBAction func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        print("saveBarButtonTapped")
        let dataService = DataService()
        let user = User()
        let todoItem = TodoItem(title: todoTitleTextField.text!, description: todoDescriptionTextView.text!, date: Date().timeIntervalSince1970, uid: user.uid!, id: nil)
        dataService.addTodoItem(todoItem: todoItem) { error in
            print("error: \(error)")
        }
    }
    
}
