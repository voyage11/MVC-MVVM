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

class TodoViewController: UIViewController {

    @IBOutlet weak var todoStackView: UIStackView!
    @IBOutlet weak var todoTableView: UITableView!
    
    var viewModel: TodoViewModel?
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
                let storyboard = UIStoryboard.init(name: K.StoryboardID.Main, bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.TodoDetailsViewController) as? TodoDetailsViewController {
                    vc.viewModel = TodoViewModel()
                    vc.todoCellViewModel = viewModel.todoCellViewModels.value[indexPath.row]
                    self?.show(vc, sender: self)
                }
                
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
    
    @IBAction func addTODOButtonTapped(_ sender: UIButton) {
        addTodoItem()
    }
    
    @IBAction func addBarButon(_ sender: UIBarButtonItem) {
        addTodoItem()
    }
    
    func addTodoItem() {
        let storyboard = UIStoryboard.init(name: K.StoryboardID.Main, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.AddTodoViewController) as? AddTodoViewController {
            vc.viewModel = TodoViewModel()
            show(vc, sender: self)
        }
    }
    
    @IBAction func profileBarButtonTapped(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard.init(name: K.StoryboardID.Main, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: K.StoryboardID.ProfileViewController) as? ProfileViewController {
            vc.viewModel = TodoViewModel()
            vc.authViewModel = AuthViewModel()
            show(vc, sender: self)
        }
    }
    
    deinit {
        //print("\(String(describing: type(of: self))) deinit")
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
