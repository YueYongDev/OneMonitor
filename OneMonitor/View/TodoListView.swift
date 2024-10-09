import SwiftUI
import EventKit

struct TodoListView: View {
    @StateObject var viewModel = TodoListViewModel()
    @State private var newReminderTitles: [EKCalendar: String] = [:]  // 每个分组的新增提醒事项标题
    @State private var editingReminder: EKReminder?   // 当前正在编辑的提醒事项
    @State private var isAddingReminder = false       // 添加防重锁，避免重复提交

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.groupedReminders.keys.sorted(by: { $0.title < $1.title }), id: \.self) { calendar in
                    Section(header: Text(calendar.title)) {
                        ForEach(viewModel.groupedReminders[calendar] ?? [], id: \.calendarItemIdentifier) { reminder in
                            HStack {
                                Button(action: {
                                    withAnimation {
                                        viewModel.toggleCompletion(for: reminder)
                                    }
                                }) {
                                    Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(reminder.isCompleted ? .green : .gray)
                                }

                                if editingReminder == reminder {
                                    TextField("Edit Reminder", text: Binding(
                                        get: { reminder.title ?? "" },
                                        set: { reminder.title = $0 }
                                    ), onCommit: {
                                        saveEditedReminder(reminder)
                                    })
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(10)
                                } else {
                                    Text(reminder.title ?? "Untitled")
                                        .onTapGesture {
                                            startEditing(reminder)
                                        }
                                }

                                Spacer()

                                if let dueDate = reminder.dueDateComponents?.date {
                                    Text("Due: \(formattedDate(dueDate))")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .contextMenu {
                                Button("Delete") {
                                    withAnimation {
                                        viewModel.deleteReminder(reminder)
                                    }
                                }
                            }
                        }

                        // 新增提醒事项的输入框
                        HStack {
                            TextField("New Reminder", text: Binding(
                                get: { newReminderTitles[calendar] ?? "" },
                                set: { newReminderTitles[calendar] = $0 }
                            ), onCommit: {
                                if let newReminderTitle = newReminderTitles[calendar], !newReminderTitle.isEmpty {
                                    if !isAddingReminder {
                                        isAddingReminder = true
                                        addNewReminder(for: calendar)
                                        newReminderTitles[calendar] = ""  // 确保输入框在添加后清空
                                        isAddingReminder = false
                                    }
                                }
                            })
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding(10)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchReminders()
        }
    }

    private func startEditing(_ reminder: EKReminder) {
        editingReminder = reminder
    }

    private func saveEditedReminder(_ reminder: EKReminder) {
        viewModel.save(reminder)
        editingReminder = nil
    }

    private func addNewReminder(for calendar: EKCalendar) {
        guard let newReminderTitle = newReminderTitles[calendar], !newReminderTitle.isEmpty else {
            return
        }

        viewModel.addReminder(
            title: newReminderTitle,
            dueDate: nil,
            priority: 0,
            calendar: calendar
        )
        newReminderTitles[calendar] = ""  // 清空输入框，防止重复添加
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
