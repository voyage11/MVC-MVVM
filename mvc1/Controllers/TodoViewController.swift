//
//  ContentViewController.swift
//  mvc1
//
//  Created by RandomMac on 24/5/20.
//  Copyright © 2020 RandomMac. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt

class TodoViewController: UIViewController {

    @IBOutlet weak var todoStackView: UIStackView!
    @IBOutlet weak var todoTableView: UITableView!
    
    var selectedRow = 0
    let viewModel = TodoViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TODO"
        todoTableView.register(UINib(nibName: K.TableCell.TodoTableViewCell, bundle: nil), forCellReuseIdentifier: K.TableCell.TodoTableViewCell)
        todoTableView.tableFooterView = UIView()
        todoTableView.dataSource = self
        todoTableView.delegate = self
        bindViewModel()
    }
    
    func bindViewModel() {
        
        viewModel.todoCellViewModels
            .asObservable()
            .subscribe(onNext: { [weak self] todoCellViewModels in
                DispatchQueue.main.async {
                    if(todoCellViewModels.count > 0) {
                        self?.todoTableView.reloadData()
                        self?.todoTableView.isHidden = false
                        self?.todoStackView.isHidden = true
                    } else {
                        self?.todoTableView.isHidden = true
                        self?.todoStackView.isHidden = false
                    }
                }
            }).disposed(by: disposeBag)
        
        todoTableView.rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.selectedRow = indexPath.row
                self?.todoTableView.deselectRow(at: indexPath, animated: true)
                self?.performSegue(withIdentifier: K.Segue.showTodoDetailsViewController, sender: self)
            }).disposed(by: disposeBag)
        
        viewModel.getTodoList()
        
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
    
    deinit {
        //print("\(String(describing: type(of: self))) deinit")
    }
    
}


extension TodoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todoCellViewModels.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableCell.TodoTableViewCell, for: indexPath) as! TodoTableViewCell
        let todoCellViewModels = viewModel.todoCellViewModels.value[indexPath.row]
        cell.todoCellViewModel = todoCellViewModels
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Complete") { [weak self] _, indexPath in
            if let id = self?.viewModel.todoCellViewModels.value[indexPath.row].id {
                self?.viewModel.deleteTodoItem(id: id)
            }
        }
        deleteAction.backgroundColor = .red
        return [deleteAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.showTodoDetailsViewController {
            let viewController = segue.destination as! TodoDetailsViewController
            viewController.todoCellViewModel = viewModel.todoCellViewModels.value[selectedRow]
        }
    }
    
}
