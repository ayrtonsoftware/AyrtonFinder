//
//  Date+Extension.swift
//  Zora
//
//  Created by Michael Paul Bergamo on 6/3/17.
//  Copyright © 2017 Ayrton Software. All rights reserved.
//
//

import Foundation

/**
 Wednesday, Sep 12, 2018           --> EEEE, MMM d, yyyy
 09/12/2018                        --> MM/dd/yyyy
 09-12-2018 14:11                  --> MM-dd-yyyy HH:mm
 Sep 12, 2:11 PM                   --> MMM d, h:mm a
 September 2018                    --> MMMM yyyy
 Sep 12, 2018                      --> MMM d, yyyy
 Wed, 12 Sep 2018 14:11:54 +0000   --> E, d MMM yyyy HH:mm:ss Z
 2018-09-12T14:11:54+0000          --> yyyy-MM-dd'T'HH:mm:ssZ
 12.09.18                          --> dd.MM.yy
 10:41:02.112                      --> HH:mm:ss.SSS
 */
public extension Date
{
    var removeTimeStamp : Date? {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            return nil
        }
        return date
    }
    
    static func parse(string: String) -> Date?
    {
        let formats = ["MMMM dd, yyyy hh:mm a",
                       "MM-dd-yyyy HH:mm",
                       "yyyy-MM-dd HH:mm:ss Z",
                       "yyyy-MM-dd HH:mm:ss a",
                       "yyyy-MM-dd hh:mm:ss",
                       "yyyy-MM-dd HH:mm:ss",
                       "MM/dd/yyyy",
                       "yyyy-MM-dd",
                       "MM/dd/yyyy HH:mma",
                       "yyyy-MM-dd HH:mma",
                       "MM/dd/yyyy HH:mm:ssa"]
        
        let formatter = DateFormatter()

        for dateFormat in formats
        {
            formatter.dateFormat = dateFormat
            if let date = formatter.date(from: string)
            {
                return date
            }
        }
        
        if string.contains(" 02:") && !string.contains(" AM") {
            return parse(string: "\(string) AM")
        }
        return nil
    }
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func toUtcString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        // "2016-11-02 04:48:53 +0800" <-- same date, local with seconds and time zone
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let utcTimeZoneStr = dateFormatter.string(from: self)
        return utcTimeZoneStr
    }
    
    func utcToLocalString(format: String = "MM/dd/yyy hh:mm:ss a") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        // "2016-11-02 04:48:53 +0800" <-- same date, local with seconds and time zone
        dateFormatter.timeZone = TimeZone.current
        let localTime = dateFormatter.string(from: self)
        return localTime
    }
    
    static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
    
    var iso8601: String {
        return Date.iso8601Formatter.string(from: self)
    }
}
