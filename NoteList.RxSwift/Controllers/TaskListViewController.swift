//
//  TaskListViewController.swift
//  NoteList.RxSwift
//
//  Created by Вадим Гамзаев on 22.01.2023.
//

import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTasks = [Task]()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func priorityValueChanged(segmentedControl: UISegmentedControl) {
        let priority = Priority(rawValue: segmentedControl.selectedSegmentIndex - 1)
        filterTask(by: priority)
    }
    
    private func updateTableView() {
        DispatchQueue.main.async { [self] in
            tableView.reloadData()
        }
    }
    
    private func filterTask(by priority: Priority?) {
        if priority == nil {
            self.filteredTasks = self.tasks.value
            self.updateTableView()
        } else {
            
            self.tasks.map { tasks in
                return tasks.filter { $0.priority == priority!}
            }.subscribe(onNext: { [weak self] tasks in
                self?.filteredTasks = tasks
                print(tasks)
            }).disposed(by: disposeBag)
            self.updateTableView()
        }
    }
    
    
    
// MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let NavC = segue.destination as? UINavigationController,
        let AddVC = NavC.viewControllers.first as? AddTaskViewController else {
            fatalError("Controllers not found")
        }
        
        AddVC.taskSubjectObservable.subscribe(onNext: { [unowned self] task in
            
            let priority = Priority(rawValue: self.segmentedControl.selectedSegmentIndex - 1)
            
            var existingTasks = self.tasks.value
            existingTasks.append(task)
            self.tasks.accept(existingTasks)
            
            self.filterTask(by: priority)
            
        }).disposed(by: disposeBag)
    }
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = filteredTasks[indexPath.row].title
        cell.contentConfiguration = content
        
        return cell
    }
}
