//
//  ToggleStateIntent.swift
//  TodoWidget
//
//  Created by Sajed Shaikh on 17/11/25.
//

import Foundation
import AppIntents
import SwiftUI

struct ToggleStateIntent: AppIntent {
    static var title: LocalizedStringResource = "Toggle Task State"
    
    @Parameter(title: "Task ID")
    var taskID: String
    
    init() {
        
    }
    
    init(taskID: String) {
        self.taskID = taskID
    }
    
    func perform() async throws -> some IntentResult {
        /// Fetch the task using the taskID and toggle its state
        if let index = TaskDataModel.shared.tasks.firstIndex(where: { $0.id == taskID }) {
            TaskDataModel.shared.tasks[index].isCompleted.toggle()
            print("completed")
        }
        return .result()
    }
}
