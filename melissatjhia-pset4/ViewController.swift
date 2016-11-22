//
//  ViewController.swift
//  melissatjhia-pset4
//
//  Created by Melissa Tjhia on 21-11-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//

import UIKit

class ViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var TasksTableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    
    private let db = DatabaseHelper()
    var tasksInDatabase: [Dictionary<String, AnyObject>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if db == nil {
            print("Error")
        }
        read()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Returns the number of TableViewCells that have to be filled.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksInDatabase.count
    }
    
    /// Fills the TableViewCell with the movie data.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.TasksTableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! TaskTableViewCell
        cell.cellData = tasksInDatabase[indexPath.row]
//        cell.taskLabel.text = cellTask["task"] as! String?
//        let cellChecked = cellTask["checked"] as! Bool
//        
//        if cellChecked {
//            strikeThrough(cell: cell)
//        }
        
        return cell
    }
    
    @IBAction func add(_ sender: Any) {
        do {
            try db!.create(task: inputTextField.text!)
            inputTextField.text = ""
            read()
            self.TasksTableView.reloadData()
            
        } catch {
            print(error)
        }
    }
    
    func read() {
        do {
            try tasksInDatabase = db!.read()
        } catch {
            print(error)
        }
    }
    
    func deleteRow(id: Int64) {
        do {
            try db!.delete(id: id)
        } catch {
            print(error)
        }
    }
    
    func updateCheckedOff(id: Int64, checked: Bool) {
        do {
            try db!.update(id:id, checked: !checked)
        } catch {
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let taskToChangeInDB = self.tasksInDatabase[indexPath.row]
        let IdtaskToChangeInDB = taskToChangeInDB["id"] as! Int64
        let isChecked = taskToChangeInDB["checked"] as! Bool
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            // Remove from the database
            self.deleteRow(id: IdtaskToChangeInDB)
            
            // Remove from the table view
            self.tasksInDatabase.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
        
        var buttonTitle = ""
        
        if isChecked {
            buttonTitle = "Uncheck"
        }
        else {
            buttonTitle = "Check"
        }
        
        let check = UITableViewRowAction(style: .normal, title: buttonTitle) { (action, indexPath) in
            
            self.updateCheckedOff(id: IdtaskToChangeInDB, checked: isChecked)
            
//            let cell = self.TasksTableView.cellForRow(at: indexPath) as! TaskTableViewCell
            self.read()
            self.TasksTableView.reloadData()
        }
        return [delete, check]
    }
    
    
}

