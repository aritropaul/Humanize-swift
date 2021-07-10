//
//  File.swift
//  
//
//  Created by Aritro Paul on 7/9/21.
//

import Foundation

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    static func - (lhs: Date, rhs: [Calendar.Component:Int]) -> Date {
        var today = lhs.get(.day, .month, .year, .hour, .minute, .second)
        for v in rhs {
            switch v.key {
                case .year: today.year! -= v.value
                case .month: today.month! -= v.value
                case .day: today.day! -= v.value
                case .hour: today.hour! -= v.value
                case .minute: today.minute! -= v.value
                case .second: today.second! -= v.value
                default: break
            }
        }
        return Calendar.current.date(from: today) ?? Date()
    }
    
    static func + (lhs: Date, rhs: [Calendar.Component:Int]) -> Date {
        var today = lhs.get(.day, .month, .year, .hour, .minute, .second)
        for v in rhs {
            switch v.key {
                case .year: today.year! += v.value
                case .month: today.month! += v.value
                case .day: today.day! += v.value
                case .hour: today.hour! += v.value
                case .minute: today.minute! += v.value
                case .second: today.second! += v.value
                default: break
            }
        }
        return Calendar.current.date(from: today) ?? Date()
    }
    
    static func DTTimeDelta(year: Int = 0, month: Int = 0, day: Int = 0, hour: Int = 0, minute: Int = 0, second: Int = 0) -> [Calendar.Component: Int] {
        return [.year: year, .month: month, .day: day, .hour: hour, .minute: minute, .second: second]
    }

}

extension Humanize {

    /// Right now, as a prettified `String` date
    /// ```
    /// Humanize().now() // 10 Jul, 2021 12:00:00
    /// ```
    /// - Parameter format: Format of the resulting date, by default it is `dd MMM, yyyy HH:mm:ss`
    /// - Returns: `String` formatted date
    public func now(format: String = "dd MMM, yyyy HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: Date())
    }
    
    /// Any given date, as a prettified `String` date
    /// ```
    /// Humanize().DTDate(date: Date()) // 10 Jul, 2021 12:00:00
    /// ```
    /// - Parameter date: Date to be converted
    /// - Parameter format: Format of the resulting date, by default it is `dd MMM, yyyy HH:mm:ss`
    /// - Returns: `String` formatted date
    public func DTDate(date: Date, format: String = "dd MMM, yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
        
    @available(macOS 10.15, *)
    /// Returns relative time passed, given a time in UTC `String`
    /// ```
    /// Humanize().relativeTime(UTCTime: "2021-07-09T04:32:27Z") // 2 days ago
    /// ```
    /// - Parameter UTCTime: Date to be converted
    /// - Returns: `String` formatted time difference
    public func relativeTime(UTCTime: String) -> String {
        let utcISODateFormatter = ISO8601DateFormatter()
        let utcDate = utcISODateFormatter.date(from: UTCTime)!
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let relativeDate = formatter.localizedString(for: utcDate, relativeTo: Date())
        return relativeDate
    }
    
    
    /// Return a natural day.
    /// For date values that are tomorrow, today or yesterday compared to
    /// present day return representing string. Otherwise, return a string
    /// formatted according to `format`
    /// ```
    /// Humanize().naturalDay(date: Date()) // Today
    /// Humanize().naturalDate(date: Date() + Date.DTTimeeDelta(days: 3) // 13 Jan
    /// ```
    /// - Parameter date: Date given
    /// - Parameter format: Resultant String Format. By Default it is `dd MMM`
    /// - Returns: `String` Formatted Day
    public func naturalDay(date: Date, format: String = "dd MMM") -> String {
        let today = Date().get(.day, .month, .year)
        let dateComp = date.get(.day, .month, .year)
        if today.year == dateComp.year && today.month == dateComp.month {
            guard let day1 = today.day, let day2 = dateComp.day else { return "" }
            if day1 == day2 {
                return "Today"
            }
            if day1 - day2 == 1 {
                return "Yesterday"
            }
            if day1 - day2 == -1 {
                return "Tomorrow"
            }
        }
        else {
            return DTDate(date: date, format: format)
        }
        return DTDate(date: date, format: format)
    }
    
    
    /// Like `naturalday`, but append a year for dates more than ~five months away."
    /// ```
    /// Humanize().naturalDate(date: Date() + Date.DTTimeDelta(day: 1)) // Tomorrow
    /// Humanize().naturalDate(date: Date() + Date.DTTimeeDelta(months: 6) // 10 Jan, 2022
    /// ```
    /// - Parameter date: Date given
    /// - Returns: `String` Formatted Day
    public func naturalDate(date: Date) -> String {
        var format: String = "dd MMM"
        let delta = Date().get(.month) - date.get(.month)
        if delta > 4 {
            format = "dd MMM, YYYY"
            return naturalDay(date: date, format: format)
        }
        return naturalDay(date: date)
    }
    
    
    
    /// Return a natural representation of a time in a resolution that makes sense.
    /// ```
    /// Humanize.naturalTime(date: Date() - Date.DTTimeDelta(second: 3600)) // 4 hours ago
    /// ```
    /// - Parameters:
    ///   - date: Date give
    /// - Returns: A natural representation of the input in a resolution that makes sense.
    public func naturalTime(date: Date) -> String {
        let today = Date().get(.hour, .minute, .second)
        let dateComp = date.get(.hour, .minute, .second)
        if today.hour == dateComp.hour && today.minute == dateComp.minute {
            guard let t1 = today.second, let t2 = dateComp.second else { return "" }
            if t1 == t2 {
                return "A moment ago"
            }
            else if t1 - t2 > 0 {
                return "\(t1 - t2) seconds ago"
            }
            else {
                return "\(t2 - t1) seconds from now"
            }
        }
        else if today.hour == dateComp.hour {
            guard let t1 = today.minute, let t2 = dateComp.minute else { return "" }
            if t1 - t2 == 1 {
                return "A minute ago"
            }
            else if t1 - t2 > 0 {
                return "\(t1 - t2) minutes ago"
            }
            else if t1 - t2 == -1 {
                return "A minute from now"
            }
            else {
                return "\(t2 - t1) minutes from now"
            }
        }
        else {
            guard let t1 = today.hour, let t2 = dateComp.hour else { return "" }
            if t1 - t2 == 1 {
                return "An hour ago"
            }
            else if t1 - t2 > 0 {
                return "\(t1 - t2) hours ago"
            }
            else if t1 - t2 == -1 {
                return "An hour from now"
            }
            else {
                return "\(t2 - t1) hours from now"
            }
        }
    }
    
}
