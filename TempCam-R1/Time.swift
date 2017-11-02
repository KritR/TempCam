 //
//  Time.swift
//  Temp Cam
//
//  Created by Krithik Rao on 6/15/15.
//  Copyright (c) 2015 Krithik Rao. All rights reserved.
//

import Foundation

struct Time{
    
    let amount: Int
    let unit: Unit
    
    enum Unit: String{
        case Minute = "Minute"
        case Hour = "Hour"
        case Day = "Day"
        case Week = "Week"
        case Month = "Month"
    }
    
    init(amount: Int, unit: Unit){
        self.amount = amount
        self.unit = unit
    }
    
    init(amount: Int, unit: String){
        self.amount = amount
        
        switch unit.capitalized{
        case Unit.Minute.rawValue.capitalized:
            self.unit = Unit.Minute
        case Unit.Hour.rawValue.capitalized:
            self.unit = Unit.Hour
        case Unit.Day.rawValue.capitalized:
            self.unit = Unit.Day
        case Unit.Week.rawValue.capitalized:
            self.unit = Unit.Week
        case Unit.Month.rawValue.capitalized:
            self.unit = Unit.Month
        default:
            self.unit = Unit.Minute
        }
    }
    
    func getTimeInterval() -> TimeInterval {
        let interval: TimeInterval
        switch unit{
        case .Minute:
            interval = TimeInterval(amount * 60)
        case .Hour:
            interval = TimeInterval(amount * 60 * 60)
        case .Day:
            interval = TimeInterval(amount * 60 * 60 * 24)
        case .Week:
            interval = TimeInterval(amount * 60 * 60 * 24 * 7)
        case .Month:
            interval = TimeInterval(amount * 60 * 60 * 24 * 31)
        }
        return interval;
    }
    
    func getTimeFromNow() -> Date {
        return Date(timeIntervalSinceNow: getTimeInterval())
    }
    
}

extension Time : CustomStringConvertible {
    var description: String{
        let desc: String = "\(amount) \(unit.rawValue)";
        if(amount > 1){
            return desc + "s"
        }
        else{
            return desc
        }
    }
}

extension Time : Comparable {
    static func < (lhs: Time, rhs: Time) -> Bool {
        return lhs.getTimeInterval() < rhs.getTimeInterval()
    }
    static func == (lhs: Time, rhs: Time) -> Bool {
        return lhs.getTimeInterval() == rhs.getTimeInterval()
    }
}
