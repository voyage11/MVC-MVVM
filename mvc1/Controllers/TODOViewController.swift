//
//  ContentViewController.swift
//  mvc1
//
//  Created by RandomMac on 24/5/20.
//  Copyright © 2020 RandomMac. All rights reserved.
//

import UIKit

class TODOViewController: UIViewController {

    @IBOutlet weak var todoStackView: UIStackView!
    @IBOutlet weak var todoTableView: UITableView!
    
    var todoList = [TodoItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TODO"
        todoTableView.register(UINib(nibName: K.TableCell.TODOTableViewCell, bundle: nil), forCellReuseIdentifier: K.TableCell.TODOTableViewCell)
        todoTableView.tableFooterView = UIView()
        todoTableView.dataSource = self
        todoTableView.delegate = self
        
        let dataService = DataService()
        let user = User()
        if let uid = user.uid {
            dataService.getTodoList(uid: uid) { [weak self] (error, todoList) in
                print("todoList: \(todoList)")
                if let e = error {
                    self?.showMessage(title: "Error", message: e, errorBool: true, successBool: false)
                } else {
                    if let todoList = todoList {
                        DispatchQueue.main.async {
                            if(todoList.count > 0) {
                                self?.todoList = todoList
                                self?.todoTableView.reloadData()
                                self?.todoTableView.isHidden = false
                                self?.todoStackView.isHidden = true
                            } else {
                                self?.todoTableView.isHidden = true
                                self?.todoStackView.isHidden = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func addTODOButtonTapped(_ sender: UIButton) {
        addTodoItem()
    }
    
    @IBAction func addBarButon(_ sender: UIBarButtonItem) {
        addTodoItem()
    }
    
    func addTodoItem() {
        performSegue(withIdentifier: K.Segue.showAddTodoViewController, sender: self)
    }
    
    @IBAction func profileBarButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.Segue.showProfileViewController, sender: self)
    }
    
}


extension TODOViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableCell.TODOTableViewCell, for: indexPath) as! TODOTableViewCell
        let todoItem = todoList[indexPath.row]
        
        cell.titleLabel.text = todoItem.title
        cell.descriptionLabel.text = todoItem.description
        cell.dateLabel.text = "\(todoItem.date)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: K.Segue.showTODODetailsViewController, sender: self)
    }
    
}