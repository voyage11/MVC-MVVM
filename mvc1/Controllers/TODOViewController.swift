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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TODO"
                
        todoTableView.register(UINib(nibName: K.TableCell.TODOTableViewCell, bundle: nil), forCellReuseIdentifier: K.TableCell.TODOTableViewCell)
        todoTableView.tableFooterView = UIView()
        todoTableView.dataSource = self
        todoTableView.delegate = self
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableCell.TODOTableViewCell, for: indexPath) as! TODOTableViewCell
        cell.titleLabel.text = "TODO List Item"
        cell.descriptionLabel.text = "TODO List Descritpiton long descriotiong. asdf "
        cell.dateLabel.text = "4 May 2020 (Tues)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: K.Segue.showTODODetailsViewController, sender: self)
    }
    
}
