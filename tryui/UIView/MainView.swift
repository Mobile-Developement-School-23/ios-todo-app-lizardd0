//
//  MainView.swift
//  tryui
//
//  Created by Елизавета Шерман on 22.06.2023.
//

import UIKit


class MainViewController: UIViewController {
    let filename = "name"
    private let fileCache = FileCache()
    private var textOfTask = TaskText()
    private var stack = Stack()
    private var deleteBut = deleteButton()
    private var itemId: String? = nil
    private var scrollView = ScrollView()
    private var importance = ImportanceStack()
    private var deadline = deadlineStack()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        
        let line = UIView()
        line.frame = CGRect()
        line.backgroundColor = .lightGray
        line.translatesAutoresizingMaskIntoConstraints = false
        self.setNavigationBar()
        
        stack.addArrangedSubview(importance)
        stack.addArrangedSubview(stack.configureLine())
        stack.addArrangedSubview(deadline)
        
        deleteBut.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 2000)
        
        scrollView.addSubview(textOfTask)
        scrollView.addSubview(stack)
        scrollView.addSubview(deleteBut)
        
        textOfTask.callbackChanged { textNotEmpty in
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.deleteBut.isEnabled = true
        }
        
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textOfTask.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            textOfTask.topAnchor.constraint(equalTo: scrollView.topAnchor),
            textOfTask.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            textOfTask.widthAnchor.constraint(equalToConstant: 365),
            stack.topAnchor.constraint(equalTo: textOfTask.bottomAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stack.widthAnchor.constraint(equalTo: textOfTask.widthAnchor, multiplier: 1),
            deleteBut.widthAnchor.constraint(equalTo: textOfTask.widthAnchor, multiplier: 1),
            deleteBut.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            deleteBut.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 34),
        ])
        
        
        if let item = readFromFile(filename: filename) {
            itemId = item.id
            textOfTask.setText(text: item.text)

            setImportance(importanceCheck: item.importance)
            deadline.setDeadlineDate(dateD: item.deadline)
            deleteBut.isEnabled = true
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        
        
    }
    
    func setImportance(importanceCheck: TodoItem.Importance) {
        switch importanceCheck {
        case TodoItem.Importance.unimportant:
            importance.importanceSwitch.selectedSegmentIndex = 0
            importance.importance = TodoItem.Importance.unimportant
        case TodoItem.Importance.ordinary:
            importance.importanceSwitch.selectedSegmentIndex = 1
            importance.importance = TodoItem.Importance.ordinary
        case TodoItem.Importance.important:
            importance.importanceSwitch.selectedSegmentIndex = 2 //все? Да!!!! ВАУУУУ!!
            importance.importance = TodoItem.Importance.important
        }
    }
    
    private func readFromFile(filename: String) -> TodoItem? {
        fileCache.readfromfileJSON(filename: filename)
        if fileCache.listofitems.count > 0 {
            return fileCache.listofitems[0]
        } else {
            return nil
        }
        
    }

    @objc private func saveToFile() {
        if let text = textOfTask.getText(),
           let importance = importance.getImportance() {
            let deadline:Date? = deadline.getDate()
            let item: TodoItem
            if let id = itemId {
                item = TodoItem(id: id, text: text, importance: importance, deadline: deadline)
            } else {
                item = TodoItem(text: text, importance: importance, deadline: deadline)
            }
            fileCache.additem(item: item)
            fileCache.savetofileJSON(filename: filename)
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @objc func deleteItem() {
        if let id = itemId {
            fileCache.deleteitem(id: id)
            fileCache.savetofileJSON(filename: filename)
        }
        
        textOfTask.setText(text: "")
        importance.setImportance(importanceCheck: TodoItem.Importance.ordinary)
        deadline.setDeadlineDate(dateD: nil)
        if !deadline.line.isHidden{
            UIView.animate(withDuration: 0.5) {
                self.deadline.line.isHidden = true
                self.deadline.calendar.isHidden = true
            }
        }
        deleteBut.isEnabled = false
    }
    
    
    private func setNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 43, width: screenSize.width, height: 87))
        let navItem = UINavigationItem(title: "Делo")
        
        let saveButton = UIBarButtonItem(title: "Сохранить", style: UIBarButtonItem.Style.done, target: self, action: #selector(saveToFile))
        navItem.rightBarButtonItem = saveButton
        
        let cancelButton = UIBarButtonItem(title: "Отменить", style: UIBarButtonItem.Style.plain, target: self, action: nil)
        
        navItem.leftBarButtonItem = cancelButton
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }
    
}

