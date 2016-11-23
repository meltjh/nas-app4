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
    }
    
    /// Returns the number of TableViewCells that have to be created.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksInDatabase.count
    }
    
    /// Sets the TableViewCell data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.TasksTableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! TaskTableViewCell
        cell.cellData = tasksInDatabase[indexPath.row]
        
        return cell
    }
    
    /// Adds the new task to the database and reloads the data and the TableView.
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
    
    /// Reads the data in the database in an array of Dictionaries.
    func read() {
        do {
            try tasksInDatabase = db!.read()
        } catch {
            print(error)
        }
    }
    
    /// Deletes the row in the database that corresponds to the cell.
    func deleteRow(id: Int64) {
        do {
            try db!.delete(id: id)
        } catch {
            print(error)
        }
    }
    
    /// Updates the (un)checked status of the task in the database.
    func updateCheckedOff(id: Int64, checked: Bool) {
        do {
            try db!.update(id:id, checked: !checked)
        } catch {
            print(error)
        }
    }
    
    /// Delete and (un)check buttons that appear when swiping to the right.
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let taskToChangeInDB = self.tasksInDatabase[indexPath.row]
        let IdtaskToChangeInDB = taskToChangeInDB["id"] as! Int64
        let isChecked = taskToChangeInDB["checked"] as! Bool
        
        // The delete button
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            // Remove from the database
            self.deleteRow(id: IdtaskToChangeInDB)
            
            // Remove from the table view
            self.tasksInDatabase.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
        
        // Button title depending on checked or not checked.
        var buttonTitle = ""
        if isChecked {
            buttonTitle = "Uncheck"
        }
        else {
            buttonTitle = "Check"
        }
        
        // The (un)check button
        let check = UITableViewRowAction(style: .normal, title: buttonTitle) { (action, indexPath) in
            
            self.updateCheckedOff(id: IdtaskToChangeInDB, checked: isChecked)
            
            // Reload data and the TableView
            self.read()
            self.TasksTableView.reloadData()
        }
        return [delete, check]
    }
}

