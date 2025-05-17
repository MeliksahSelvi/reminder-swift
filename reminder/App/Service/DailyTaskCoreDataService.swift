//
//  DailyTaskCoreDataService.swift
//  reminder
//
//  Created by Melik on 11.05.2025.
//

import UIKit
import CoreData

protocol DailyTaskServiceProtocol {
    func createTask(newTask: DailyTask)
    func updateTask(task: DailyTask)
    func getAllTasks() -> [DailyTask]
    func getAllTasksForSpecificDate(date: Date) -> [DailyTask]
    func deleteTask(task: DailyTask)
}

class DailyTaskCoreDataService : DailyTaskServiceProtocol{
    
    private let context: NSManagedObjectContext
        
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Create
    func createTask(newTask : DailyTask) {
        let taskEntity = newTask.toEntity(context: context)
        saveContext()
    }
    
    // MARK: - Get All Tasks
    func getAllTasks() -> [DailyTask] {
        let fetchRequest: NSFetchRequest<DailyTaskEntity> = DailyTaskEntity.fetchRequest() as! NSFetchRequest<DailyTaskEntity>
            
        do {
            let taskEntities = try context.fetch(fetchRequest)
            return taskEntities.map { $0.toModel() }
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }
    
    // MARK: - Get Tasks By Date
    func getAllTasksForSpecificDate(date: Date) -> [DailyTask] {
        let fetchRequest: NSFetchRequest<DailyTaskEntity> = DailyTaskEntity.fetchRequest() as! NSFetchRequest<DailyTaskEntity>
        
        let utcCalendar = DateUtil.utcCalendar
        let startOfDay = utcCalendar.startOfDay(for: date) // 00:00
        let endOfDay = utcCalendar.date(byAdding: .day, value: 1, to: startOfDay)!
        //print("startOfDay: \(startOfDay) , endOfDay: \(endOfDay)")

        let predicate = NSPredicate(format: "remindAt >= %@ AND remindAt < %@", startOfDay as NSDate, endOfDay as NSDate)
        fetchRequest.predicate = predicate
        
        let sortByIsCompleted = NSSortDescriptor(key: "isCompleted", ascending: false)
        let sortByCompletedAt = NSSortDescriptor(key: "completedAt", ascending: true)
        let sortByRemindAt = NSSortDescriptor(key: "remindAt", ascending: true)
        fetchRequest.sortDescriptors = [sortByIsCompleted, sortByCompletedAt, sortByRemindAt]
        
        do {
            let taskEntities = try context.fetch(fetchRequest)
            return taskEntities.map { $0.toModel() }
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }
    
    // MARK: - Delete Task
    func deleteTask(task: DailyTask) {
        let fetchRequest: NSFetchRequest<DailyTaskEntity> = DailyTaskEntity.fetchRequest() as! NSFetchRequest<DailyTaskEntity>
        fetchRequest.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
            
        do {
            let taskEntities = try context.fetch(fetchRequest)
            if let taskEntityToDelete = taskEntities.first {
                context.delete(taskEntityToDelete)
                saveContext()
            }
        } catch {
            print("Failed to delete task: \(error)")
        }
    }
    
    func updateTask(task: DailyTask) {
        let fetchRequest: NSFetchRequest<DailyTaskEntity> = DailyTaskEntity.fetchRequest() as! NSFetchRequest<DailyTaskEntity>
        fetchRequest.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
            
        do {
            let taskEntities = try context.fetch(fetchRequest)
            if let taskEntityToUpdate = taskEntities.first {
                taskEntityToUpdate.title = task.title
                taskEntityToUpdate.remindAt = task.remindAt
                taskEntityToUpdate.completedAt = task.completedAt
                taskEntityToUpdate.isCompleted = task.isCompleted
                saveContext()
            }
        } catch {
            print("Failed to update task: \(error)")
        }
    }
    
    
    // MARK: - Save Context
        private func saveContext() {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print("Failed to save context: \(error)")
                }
            }
        }
}
