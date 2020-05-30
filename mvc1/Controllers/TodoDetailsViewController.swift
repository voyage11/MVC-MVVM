//
//  TODODetailsViewController.swift
//  mvc1
//
//  Created by RandomMac on 25/5/20.
//  Copyright © 2020 RandomMac. All rights reserved.
//

import UIKit

class TodoDetailsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var todoItem: TodoItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let todoItem = todoItem {
            self.title = todoItem.title
            titleLabel.text = todoItem.title
            descriptionLabel.text = todoItem.description
            dateLabel.text = todoItem.dateString()
        }
    }
    
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        guard let todoItem = todoItem, let id = todoItem.id else {
            return
        }
        let dataService = DataService()
        dataService.deleteTodoItem(id: id) { [weak self] error in
            if let e = error {
                let alertMessage = AlertMessage(title: "Error", message:e, alertType: .error)
                self?.showMessage(alertMessage: alertMessage)
            } else {
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
