//
//  DateExt.swift
//  ZonkyStatistics
//
//  Created by Sadi on 13/01/2019.
//  Copyright © 2019 Sadi. All rights reserved.
//

import Foundation

extension Date {
    
    var millisecondsSince1970:Double {
        return Double((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Double) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }

    func getNextMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)
    }

    func getPreviousMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)
    }

    func getMonthStart() -> Date? {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components)!
    }
    
    func getYearStart() -> Date? {
        let year = Calendar.current.component(.year, from: self)
        return Calendar.current.date(from: DateComponents(year: year, month: 1, day: 1))
    }
    
    func getYearEnd() -> Date? {
        let year = Calendar.current.component(.year, from: self)
        return Calendar.current.date(from: DateComponents(year: year, month: 12, day: 31))
    }

    func getMonthEnd() -> Date? {
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 1
        components.day = 1
        components.day -= 1
        return Calendar.current.date(from: components as DateComponents)!
    }
    
    func getNextMonthStart() -> Date? {
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 1
        return Calendar.current.date(from: components as DateComponents)!
    }
    
    func getNextMonthEnd() -> Date? {
        let components:NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.day = 1
        components.day += 1
        return Calendar.current.date(from: components as DateComponents)!
    }

    func diffInMonths(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    
    func firstAndLastDayOfYear(offset:Int)-> (firstDay:Date, lastDay:Date){
        let firtsDayInYear = Calendar.current.date(byAdding: .year, value: offset, to: self.getYearStart()!)!
        let LastDayInYear = Calendar.current.date(byAdding: .year, value: offset, to: self.getYearEnd()!)!
        return (firtsDayInYear,LastDayInYear)
    }

    func getYear(add:Int=0)-> String{
        let df = DateFormatter()
        df.dateFormat = "yyyy"
        let d = Calendar.current.date(byAdding: .year, value: add, to: self)!
        return df.string(from:d)
    }
}
