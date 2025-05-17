//
//  TaskViewModel.swift
//  reminder
//
//  Created by Melik on 15.05.2025.
//

import Foundation
protocol TaskViewModelProtocol {
    
    func assignDelegate(delegate: TaskViewControllerProtocol)
    func updateTitle(_ title: String)
    func updateDate(_ date: Date)
    func updateTime(_ time: Date)
    func saveTask()
    func getTask() -> DailyTask?
}

final class TaskViewModel: TaskViewModelProtocol {
    
    private weak var delegate : TaskViewControllerProtocol?
    private let dailyTaskService: DailyTaskServiceProtocol
    
    private var currentTitle: String
    private var currentDate: Date
    private var currentTime: Date
    private var task: DailyTask?
    
    init(dailyTaskService: DailyTaskServiceProtocol, task: DailyTask?){
        self.dailyTaskService = dailyTaskService
        self.task = task
        self.currentTitle = task?.title ?? ""
        let date = task?.remindAt ?? Date()
        self.currentDate = date
        self.currentTime = date
    }
    
    func assignDelegate(delegate: TaskViewControllerProtocol) {
        self.delegate = delegate
    }
    
    func getTask() -> DailyTask? {
        return self.task
    }
    
    func updateTitle(_ title: String) {
        currentTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        delegate?.updateSaveButtonValidity(isEnabled: currentTitle.isEmpty == false)
    }
    
    func saveTask() {
        let calendar = DateUtil.calendar
    
        let dayComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: currentTime)
    
        var combinedComponents = DateComponents()
        combinedComponents.year = dayComponents.year
        combinedComponents.month = dayComponents.month
        combinedComponents.day = dayComponents.day
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute
        //combinedComponents.timeZone = TimeZone(abbreviation: "UTC")!
    
        if let combinedDate = calendar.date(from: combinedComponents) {
            print("combinedDate \(combinedDate)")
            if let task = self.task  {
                let dailyTaskToUpdated: DailyTask = DailyTask (
                    id: task.id,
                    title:currentTitle,
                    remindAt: combinedDate,
                    completedAt: task.completedAt,
                    isCompleted: task.isCompleted
                )
                print(" update task \(dailyTaskToUpdated)")
            
                dailyTaskService.updateTask(task: dailyTaskToUpdated)
            }else {
                let dailyTask = DailyTask(title: currentTitle, remindAt: combinedDate)
                print("persist task \(dailyTask)")
            
                dailyTaskService.createTask(newTask: dailyTask)
            }
            delegate?.executeSaveAfterActions()
        } else {
            print("Tarih oluşturulamadı.")
        }
    }
    func updateDate(_ date: Date) {
        currentDate = date
        let isEnabled = self.isButtonEnabled(date: currentDate)
        delegate?.updateSaveButtonValidity(isEnabled: isEnabled)
    }
    
    func updateTime(_ time: Date) {
        currentTime = time
        let isEnabled = self.isButtonEnabled(date: currentTime)
        delegate?.updateSaveButtonValidity(isEnabled: isEnabled)
    }
    
    private func isButtonEnabled(date: Date) -> Bool {
        var isSame : Bool
        if let task = self.task {
            isSame = DateUtil.isSameMinute(task.remindAt, date)
        }else{
            isSame = false
        }
        return isSame == false
    }

}

final class PreviewTaskViewModel : TaskViewModelProtocol {
    
    func assignDelegate(delegate: TaskViewControllerProtocol){}
    func updateTitle(_ title: String){}
    func updateDate(_ date: Date){}
    func updateTime(_ time: Date){}
    func saveTask(){}
    func getTask() -> DailyTask? {return nil}
}

