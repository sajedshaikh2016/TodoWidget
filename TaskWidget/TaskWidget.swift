//
//  TaskWidget.swift
//  TaskWidget
//
//  Created by Sajed Shaikh on 17/11/25.
//

import WidgetKit
import SwiftUI
import AppIntents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TaskEntry {
        // Customize a placeholder view.
        TaskEntry(latestThreeTasks: Array(TaskDataModel.shared.tasks.prefix(3)))
    }

    func getSnapshot(in context: Context, completion: @escaping (TaskEntry) -> ()) {
        let entry = TaskEntry(latestThreeTasks: Array(TaskDataModel.shared.tasks.prefix(3)))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        /// Fetch data here
        let latestTasks = Array(TaskDataModel.shared.tasks.prefix(3))
        let latestEntries = [TaskEntry(latestThreeTasks: latestTasks)]
        let timeline = Timeline(entries: latestEntries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct TaskEntry: TimelineEntry {
    let date: Date = .now
    var latestThreeTasks: [TaskModel]
}

struct TaskWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            Text("Latest Tasks")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.bottom, 10)
            VStack(alignment: .leading, spacing: 6, content: {
                if entry.latestThreeTasks.isEmpty {
                    Text("No Tasks Available")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                } else {
                    ForEach(entry.latestThreeTasks.sorted {
                        $0.isCompleted && !$1.isCompleted
                    }) { task in
                        HStack(spacing: 6) {
                            Button(intent: ToggleStateIntent(taskID: task.id)) {
                                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(task.isCompleted ? .green : .gray)
                            }
                            .buttonStyle(.plain)
                            
                            VStack(alignment: .leading, spacing: 4, content: {
                                Text(task.title)
                                    .font(.subheadline)
                                    .lineLimit(1)
                                    .strikethrough(task.isCompleted, pattern: .solid, color: .gray)
//                                Divider()
                            })
                            
                            if task.id != entry.latestThreeTasks.last?.id {
                                Spacer(minLength: 0)
                            }
                        }
                    }
                }
            })
        })
    }
}

struct TaskWidget: Widget {
    let kind: String = "TaskWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                TaskWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                TaskWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Task Widget")
        .description("This is an example of interactive widget.")
    }
}

#Preview(as: .systemSmall) {
    TaskWidget()
} timeline: {
    TaskEntry(latestThreeTasks: TaskDataModel.shared.tasks)
}
