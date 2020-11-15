//
//  String+Extension.swift
//  EventLists
//
//  Created by YOU-HSUAN YU on 2020/11/15.
//

import Foundation

extension String {
    func dateFormatted(pattern: String) -> String {
        guard let timeInterval = TimeInterval(self) else {
            return pattern
        }
        let date = Date(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = pattern
        return "\(dateFormatter.string(from: date))"
    }
}
