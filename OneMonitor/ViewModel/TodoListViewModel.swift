import EventKit

class TodoListViewModel: ObservableObject {
    private let eventStore = EKEventStore()
    @Published var groupedReminders: [EKCalendar: [EKReminder]] = [:]
    
    init() {
        requestAccessToReminders()
    }
    
    func requestAccessToReminders() {
        eventStore.requestAccess(to: .reminder) { [weak self] (granted, error) in
            DispatchQueue.main.async {
                if granted {
                    self?.fetchReminders()
                } else {
                    print("Access denied: \(String(describing: error))")
                }
            }
        }
    }
    
    func fetchReminders() {
        let predicate = eventStore.predicateForReminders(in: nil)
        eventStore.fetchReminders(matching: predicate) { [weak self] reminders in
            DispatchQueue.main.async {
                if let reminders = reminders {
                    self?.groupRemindersByCalendar(reminders)
                } else {
                    self?.groupedReminders = [:]
                }
            }
        }
    }
    
    private func groupRemindersByCalendar(_ reminders: [EKReminder]) {
        var grouped: [EKCalendar: [EKReminder]] = [:]
        let uncompletedReminders = reminders.filter { !$0.isCompleted }
        for reminder in uncompletedReminders {
            if let calendar = reminder.calendar {
                grouped[calendar, default: []].append(reminder)
            }
        }
        self.groupedReminders = grouped
    }

    func toggleCompletion(for reminder: EKReminder) {
        reminder.isCompleted.toggle()
        save(reminder)
    }
    
    func save(_ reminder: EKReminder) {
        do {
            try eventStore.save(reminder, commit: true)
            fetchReminders() // 更新视图
        } catch {
            print("Error saving reminder: \(error.localizedDescription)")
        }
    }

    // 删除提醒事项
    func deleteReminder(_ reminder: EKReminder) {
        do {
            try eventStore.remove(reminder, commit: true)  // 删除提醒事项
            fetchReminders()  // 重新获取数据以更新视图
        } catch {
            print("Error deleting reminder: \(error.localizedDescription)")
        }
    }
    
    // 手动添加提醒事项
    func addReminder(title: String, dueDate: Date?, priority: Int, calendar: EKCalendar?) {
        let reminder = EKReminder(eventStore: eventStore)
        reminder.title = title
        reminder.calendar = calendar ?? eventStore.defaultCalendarForNewReminders() // 默认使用系统日历
        reminder.priority = priority
        if let dueDate = dueDate {
            reminder.dueDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        }
        
        save(reminder)
    }
}
