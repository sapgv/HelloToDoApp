//
//  TaskStorage.swift
//  HelloToDoApp
//
//  Created by Grigory Sapogov on 04.09.2024.
//

import Foundation

final class TaskStorage {
    
    private let key = "tasks"
    
    func fetch() throws -> [Task] {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data else { return [] }
        let decoder = JSONDecoder()
        let items = try decoder.decode([Task].self, from: data)
        return items
    }
    
    func save(task newTask: Task) throws {
        
        let tasks = try self.fetch()
        
        var saveTasks: [Task] = []

        var newTaskAdded = false
        for task in tasks {
            if newTask.id == task.id {
                saveTasks.append(newTask)
                newTaskAdded = true
            }
            else {
                saveTasks.append(task)
            }
        }
        
        if !newTaskAdded {
            saveTasks.append(newTask)
        }
        
        let encoder = JSONEncoder()
        
        let encoded = try encoder.encode(saveTasks)
        
        UserDefaults.standard.set(encoded, forKey: key)
        UserDefaults.standard.synchronize()
        
    }
    
    func delete(task: Task) throws {
        
        var tasks = try self.fetch()
        
        tasks.removeAll(where: { $0.id == task.id })
        
        let encoder = JSONEncoder()
        
        let encoded = try encoder.encode(tasks)
        
        UserDefaults.standard.set(encoded, forKey: key)
        UserDefaults.standard.synchronize()
        
    }
    
}
