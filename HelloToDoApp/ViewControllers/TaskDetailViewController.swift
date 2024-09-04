//
//  TaskDetailViewController.swift
//  HelloToDoApp
//
//  Created by Grigory Sapogov on 04.09.2024.
//

import UIKit

final class TaskDetailViewController: UIViewController {
    
    var task: Task!
    
    var completion: ((UIViewController) -> Void)?
    
    var storage: TaskStorage?
    
    private let textField: UITextField = UITextField()
    
    private let switcher: UISwitch = UISwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Task"
        self.view.backgroundColor = .systemBackground
        self.layoutView()
        self.setupNavigationItems()
        self.setupTextField()
        self.setupSwitcher()
        self.updateView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textField.becomeFirstResponder()
    }
    
    private func layoutView() {
        
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.switcher.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(textField)
        self.view.addSubview(switcher)
        
        self.textField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        self.textField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        self.textField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        
        self.switcher.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        self.switcher.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 8).isActive = true
        self.switcher.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        
    }
    
    private func setupNavigationItems() {
        
        let saveAction = UIAction { [weak self] _ in
            self?.save()
        }
        let saveButton = UIBarButtonItem(systemItem: .save, primaryAction: saveAction)
        
        let cancelAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            self.completion?(self)
        }
        let cancelButton = UIBarButtonItem(systemItem: .cancel, primaryAction: cancelAction)
        
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.leftBarButtonItem = cancelButton
        
    }
    
    //MARK: - Text Field
    
    private func setupTextField() {
        
        self.textField.borderStyle = .roundedRect
        
        self.textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        
    }
    
    @objc
    private func textChanged(_ sender: UITextField) {
        
        self.task.title = sender.text ?? ""
        
    }
    
    //MARK: - Switcher
    
    private func setupSwitcher() {
        
        self.switcher.addTarget(self, action: #selector(switcherChanged), for: .valueChanged)
        
    }
    
    @objc
    private func switcherChanged(_ sender: UISwitch) {
        
        self.task.done = sender.isOn
        
    }
    
    //MARK: - Save
    
    private func save() {
        
        try? self.storage?.save(task: self.task)
        
        self.completion?(self)
        
    }
    
    //MARK: - Update
    
    private func updateView() {
        self.textField.text = self.task.title
        self.switcher.isOn = self.task.done
    }
    
}
