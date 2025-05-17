//
//  Extensions.swift
//  reminder
//
//  Created by Melik on 8.05.2025.
//

import Foundation
import CoreData

extension Date {
    /// Kotlin'deki LocalDate.toEpochDay() karşılığı.
    var epochDay: Int {
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = TimeZone(secondsFromGMT: 0)! // UTC zaman dilimi
            
            let startOfDay = calendar.startOfDay(for: self)
            let referenceDate = calendar.startOfDay(for: Date(timeIntervalSince1970: 0)) // 1970-01-01
            
            let components = calendar.dateComponents([.day], from: referenceDate, to: startOfDay)
            return components.day ?? 0
        }
    
    static func fromEpochDay(_ epochDay: Int) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)! // UTC zaman dilimi
        
        let referenceDate = calendar.startOfDay(for: Date(timeIntervalSince1970: 0)) // 1970-01-01
        let targetDate = calendar.date(byAdding: .day, value: epochDay, to: referenceDate)!
        
        return targetDate
        
    }
}

extension DailyTaskEntity {
    func toModel() -> DailyTask {
        DailyTask(
            id: self.id,
            title: self.title,
            remindAt: self.remindAt,
            completedAt: self.completedAt,
            isCompleted: self.isCompleted
        )
    }
}

extension DailyTask {
    func toEntity(context: NSManagedObjectContext) -> DailyTaskEntity {
        let entity = DailyTaskEntity(context: context)
        entity.id = self.id
        entity.title = self.title
        entity.remindAt = self.remindAt
        entity.completedAt = self.completedAt
        entity.isCompleted = self.isCompleted
        return entity
    }
}
