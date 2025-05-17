//
//  DailyTaskEntity.swift
//  reminder
//
//  Created by Melik on 11.05.2025.
//

import CoreData


 @objc(DailyTaskEntity)
 class DailyTaskEntity: NSManagedObject {
 @NSManaged var id: UUID
 @NSManaged var title: String
 @NSManaged var remindAt: Date
 @NSManaged var completedAt: Date?
 @NSManaged var isCompleted: Bool
 }
 
 
