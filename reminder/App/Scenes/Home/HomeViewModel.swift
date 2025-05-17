//
//  HomeViewModel.swift
//  reminder
//
//  Created by Melik on 16.05.2025.
//

import Foundation

protocol HomeViewModelProtocol : AnyObject {
    
    func assignDelegate(delegate: HomeViewControllerProtocol )
    func getAllTasksByDate(date: Date) -> [DailyTask]
    func updateTask(newTask : DailyTask)
    func deleteTask(task: DailyTask)
    func getDisplayedDates(date: Date?) -> [Date]
    func setCompletionTime(completedAt: Date?) -> String
    func buildGreetingMessage() -> String
    func isPlusImageHidden(date: Date) -> Bool
    func areTheySameDay(date1: Date, date2: Date) -> Bool
}

class HomeViewModel : HomeViewModelProtocol {
    
    private weak var delegate : HomeViewControllerProtocol?
    
    private let dailyTaskService: DailyTaskServiceProtocol
    private let userDefaultsService: UserDefaultsServiceProtocol
    
    init(dailyTaskService: DailyTaskServiceProtocol, userDefaultsService: UserDefaultsServiceProtocol) {
        self.dailyTaskService = dailyTaskService
        self.userDefaultsService = userDefaultsService
    }
    
    func assignDelegate(delegate: HomeViewControllerProtocol) {
        self.delegate = delegate
    }
    
    func getAllTasksByDate(date: Date) -> [DailyTask] {
        return self.dailyTaskService.getAllTasksForSpecificDate(date: date)
    }
    
    func updateTask(newTask: DailyTask) {
        self.dailyTaskService.updateTask(task: newTask)
    }
    
    func deleteTask(task: DailyTask) {
        self.dailyTaskService.deleteTask(task: task)
    }

    func getDisplayedDates(date: Date? = nil) -> [Date] {
        return DateUtil.surroundingDays(date: date, count: 4)
    }
    
    func setCompletionTime(completedAt: Date?) -> String {
        if let completedAt = completedAt {
            let formatter = DateFormatter()
            
            let calendar = DateUtil.calendar
            let isToday = calendar.isDateInToday(completedAt)
            let isYesterday = calendar.isDateInYesterday(completedAt)
            
            if isToday {
                formatter.dateFormat = "h:mm a"
                return  "completed today at " + formatter.string(from: completedAt)
            } else if isYesterday {
                formatter.dateFormat = "h:mm a"
                return "completed yesterday at " + formatter.string(from: completedAt)
            } else {
                formatter.dateFormat = "dd-MM-yyyy h:mm a"
                return "completed on " + formatter.string(from: completedAt)
            }
        } else {
            return ""
        }
    }
    
    func buildGreetingMessage() -> String {
        let username = userDefaultsService.getUsername() ?? ""
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
            case 5..<12:
                return "Good Morning \(username)"
            case 12..<17:
                return "Good Afternoon \(username)"
            case 17..<22:
                return "Good Evening \(username)"
            default:
                return "Good Night \(username)"
        }
    }
    
    func isPlusImageHidden(date: Date) -> Bool {
        return DateUtil.isLowerThanNow(date)
    }
    
    func areTheySameDay(date1: Date, date2: Date) -> Bool {
        return DateUtil.isSameDay(date1, date2)
    }
}


