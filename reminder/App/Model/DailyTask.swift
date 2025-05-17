    //
    //  DailyTask.swift
    //  reminder
    //
    //  Created by Melik on 4.05.2025.
    //

    import Foundation

    struct DailyTask :Comparable {
        let id: UUID
        var title: String
        var remindAt: Date
        var completedAt: Date?
        var isCompleted: Bool
        
        init(id: UUID = UUID() , title: String, remindAt: Date = Date(),completedAt: Date? = nil, isCompleted: Bool = false) {
            self.id = id
            self.title = title
            self.remindAt = remindAt
            self.completedAt = completedAt
            self.isCompleted = isCompleted
        }
        
        static func < (lhs: DailyTask, rhs: DailyTask) -> Bool {
            if lhs.isCompleted && rhs.isCompleted {
                guard let lhsCompleted = lhs.completedAt, let rhsCompleted = rhs.completedAt else {
                    return lhs.completedAt != nil
                }
                return lhsCompleted < rhsCompleted
            } else if !lhs.isCompleted && !rhs.isCompleted {
                return lhs.remindAt < rhs.remindAt
            } else {
                return lhs.isCompleted
            }
        }
    }
