//
//  TaskListViewController.swift
//  HelloToDoApp
//
//  Created by Grigory Sapogov on 04.09.2024.
//

import UIKit

final class TaskListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let tableView = UITableView()
    
    private var tasks: [Task] = []
    
    private let storage: TaskStorage = TaskStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tasks"
        self.layoutView()
        self.setupNavigationItems()
        self.setupTableView()
        self.updateData()
    }
    
    private func setupNavigationItems() {
        
        let addAction = UIAction { [weak self] _ in
            let newTask = Task()
            self?.showDetail(task: newTask)
        }
        let addButton = UIBarButtonItem(systemItem: .add, primaryAction: addAction)
        self.navigationItem.rightBarButtonItem = addButton
        
    }

    private func layoutView() {
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(tableView)
        
        self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
    }
    
    //MARK: - Table View
    
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = self.tasks[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = task.title
        cell.accessoryType = task.done ? .checkmark : .none
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let task = self.tasks[indexPath.row]
        
        self.showDetail(task: task)
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let task = self.tasks[indexPath.row]
        
        let deletaAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, completion in
            
            self.showDeleteDialog(task: task)
            
            completion(true)
            
        }
        
        let config = UISwipeActionsConfiguration(actions: [deletaAction])
        
        return config
        
    }
    
    //MARK: - Update
    
    private func updateData() {
        
        defer {
            self.tableView.reloadData()
        }
        
        guard let tasks = try? self.storage.fetch() else {
            self.tasks.removeAll()
            return
        }
        
        self.tasks = tasks
        
    }
    
    //MARK: - Show Detail View Controller
    
    private func showDetail(task: Task) {
        
        let taskDetailViewController = TaskDetailViewController()
        taskDetailViewController.storage = self.storage
        taskDetailViewController.task = task
        taskDetailViewController.completion = { [weak self] detailViewController in
            detailViewController.dismiss(animated: true) {
                self?.updateData()
            }
        }
        
        let navigationController = UINavigationController(rootViewController: taskDetailViewController)
        
        self.present(navigationController, animated: true)
        
    }
    
    //MARK: - Show Delete Dialog
    
    private func showDeleteDialog(task: Task) {
        
        let deleteAction = UIAlertAction(title: "Удалить", style: .default, handler: { _ in
            self.deleteTask(task: task)
        })
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        let alert = UIAlertController(title: "Удалить задачу ?", message: nil, preferredStyle: .alert)
         
        alert.addAction(deleteAction)
        
        alert.addAction(cancelAction)
         
        self.present(alert, animated: true)
        
    }
    
    //MARK: - Delete Task
    
    private func deleteTask(task: Task) {
        
        try? self.storage.delete(task: task)
        
        self.updateData()
        
    }
    

}

