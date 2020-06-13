//
//  ContentViewController.swift
//  mvc-mvvm
//
//  Created by Ricky on 24/5/20.
//  Copyright © 2020 Ricky. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt

protocol TodoViewControllerDelegate {
    func showAddTodoViewController()
    func showTodoDetailsViewController(_ todoCellViewModel: TodoCellViewModel)
    func showProfileViewController()
}

class TodoViewController: UIViewController {

    @IBOutlet weak var todoStackView: UIStackView!
    @IBOutlet weak var todoTableView: UITableView!
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var profileBarButton: UIBarButtonItem!
    
    var delegate: TodoViewControllerDelegate?
    var viewModel: TodoViewModel?
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel?.title
        todoTableView.register(UINib(nibName: K.TableCell.TodoTableViewCell, bundle: nil), forCellReuseIdentifier: K.TableCell.TodoTableViewCell)
        todoTableView.tableFooterView = UIView()
        todoTableView.dataSource = self
        todoTableView.delegate = self
        bindViewModel()
    }
    
    func bindViewModel() {
        guard let viewModel = viewModel else { return }
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
                self?.todoTableView.deselectRow(at: indexPath, animated: true)
                let todoCellViewModel = viewModel.todoCellViewModels.value[indexPath.row]
                self?.delegate?.showTodoDetailsViewController(todoCellViewModel)
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
            .onShowLoading
            .subscribe(onNext: { [weak self] isLoading in
                if(isLoading) {
                    self?.startAnimating()
                } else {
                    self?.stopAnimating()
                }
            }).disposed(by: disposeBag)
    }
    
    @IBAction func addTodoButtonTapped(_ sender: UIButton) {
        addTodoItem()
    }
    
    @IBAction func addTodoBarButon(_ sender: UIBarButtonItem) {
        addTodoItem()
    }
    
    func addTodoItem() {
        delegate?.showAddTodoViewController()
    }
    
    @IBAction func profileBarButtonTapped(_ sender: UIBarButtonItem) {
        delegate?.showProfileViewController()
    }
    
    deinit {
        if K.showPrint {
            print("\(String(describing: type(of: self))) deinit")
        }
    }
    
}


extension TodoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.todoCellViewModels.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
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
            if let viewModel = self?.viewModel, let id = viewModel.todoCellViewModels.value[indexPath.row].id {
                viewModel.deleteTodoItem(id: id)
            }
        }
        deleteAction.backgroundColor = .red
        return [deleteAction]
    }
    
}
