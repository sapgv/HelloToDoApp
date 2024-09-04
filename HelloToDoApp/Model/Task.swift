//
//  Task.swift
//  HelloToDoApp
//
//  Created by Grigory Sapogov on 04.09.2024.
//

import Foundation

final class Task: Codable {
    
    let id: UUID
    
    var title: String
    
    var done: Bool
    
    init(id: UUID = UUID(), title: String = "", done: Bool = false) {
        self.id = id
        self.title = title
        self.done = done
    }
    
}
