//
//  DatabaseHelper.swift
//  melissatjhia-pset4
//
//  Created by Melissa Tjhia on 22-11-16.
//  Copyright © 2016 Melissa Tjhia. All rights reserved.
//

import Foundation
import SQLite

class DatabaseHelper {
    private let tasks = Table("tasks")
    
    private let id = Expression<Int64>("id")
    private let task = Expression<String?>("task")
    private let checked = Expression<Bool>("checked")
    
    private var db: Connection?
    
    init? () {
        do {
            try setupDatabase()
        } catch {
            print(error)
            return nil
        }
    }
    
    private func setupDatabase() throws {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do {
            db = try Connection("\(path)/db.sqlite3")
//            try db?.run(tasks.drop())
            try createTable()
        } catch {
            throw error
        }
    }
    
    private func createTable() throws {
        do {
            try db!.run(tasks.create(ifNotExists: true) {
                t in
                t.column(id, primaryKey: .autoincrement)
                t.column(task)
                t.column(checked)
            })
        } catch {
            throw error
        }
    }
    
    func create(task: String) throws {
        let insert = tasks.insert(self.task <- task, self.checked <- false)
        
        do {
            _ = try db!.run(insert)
        } catch {
            throw error
        }
    }
    
    func read() throws -> [Dictionary<String, AnyObject>]{
        var results: [Dictionary<String, AnyObject>] = []
        
        do {
            for task_item in try db!.prepare(tasks) {
                results.append(["id": task_item[id] as AnyObject, "task": task_item[task] as AnyObject, "checked": task_item[checked] as AnyObject])
            }
        } catch {
            throw error
        }
        return results
    }
    
    func update(id: Int64, checked: Bool) throws {
        do {
            _ = try db!.run(tasks.filter(id == self.id).update(self.checked <- checked))
        } catch {
            throw error
        }
    }
    
    func delete(id: Int64) throws {
        do {
            _ = try db!.run(tasks.filter(id == self.id).delete())
        } catch {
            throw error
        }
    }
}
