//
//  DateUtil.swift
//  reminder
//
//  Created by Melik on 8.05.2025.
//
import Foundation

struct DateUtil {
    
    static var utcCalendar: Calendar = {
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = TimeZone(identifier: "UTC")!
            return calendar
    }()
    
    static var calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        return calendar
    }()
    
    static func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    static func isSameMinute(_ date1: Date, _ date2: Date) -> Bool {
        return calendar.isDate(date1, equalTo: date2, toGranularity: .minute)
    }
    
    static func isLowerThanNow(_ date: Date) -> Bool {
        let startOfNow :Date = DateUtil.calendar.startOfDay(for: .now)
        let startOfDate : Date = DateUtil.calendar.startOfDay(for: date)
        return startOfNow > startOfDate
    }
    
    static func nextDayThan(_ date: Date) -> Date {
        return calendar.date(byAdding: .day, value: 1, to: date)!
    }

    static func previousDayThan(_ date: Date) -> Date {
        return calendar.date(byAdding: .day, value: -1, to: date)!
    }
    
    static func surroundingDays(date: Date?, count: Int) -> [Date] {
        guard count >= 0 else { return [] }
        let center: Date = date ?? .now
        let range = (-count)...count
        return range.compactMap {
            utcCalendar.date(byAdding: .day, value: $0, to: center)
        }
    }
     
}
