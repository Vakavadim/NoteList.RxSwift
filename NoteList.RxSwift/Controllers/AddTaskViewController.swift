//
//  AddTaskViewController.swift
//  NoteList.RxSwift
//
//  Created by Вадим Гамзаев on 22.01.2023.
//

import UIKit
import RxSwift

class AddTaskViewController: UIViewController {
    
    private let taskSubject = PublishSubject<Task>()
    
    var taskSubjectObservable: Observable<Task> {
        return taskSubject.asObservable()
    }
    
    @IBOutlet weak var prioritySegmentedController: UISegmentedControl!
    @IBOutlet weak var taskTitleTextField: UITextField!
    
    @IBAction func Save() {
        guard let priority = Priority(
            rawValue: self.prioritySegmentedController.selectedSegmentIndex
        ), let title = taskTitleTextField.text else { return }
        let task = Task(title: title, priority: priority)
        
        taskSubject.onNext(task)
        
        dismiss(animated: true)
    }
}

