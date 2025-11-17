//
//  TaskModel.swift
//  TodoWidget
//
//  Created by Sajed Shaikh on 17/11/25.
//

import SwiftUI

struct TaskModel: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var isCompleted: Bool = false
    
     // Other properties and methods can be added here
}

// Sample Data Model
class TaskDataModel {
    static let shared = TaskDataModel()

    var tasks: [TaskModel]  = [
        .init(title: "Buy groceries", isCompleted: false),
        .init(title: "Walk the dog", isCompleted: true),
        .init(title: "Read a book", isCompleted: false)
    ]
}
