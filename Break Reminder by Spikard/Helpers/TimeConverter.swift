//
//  TimeConverter.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 27/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

final class TimeConverter {
    
    class func timerString(from timeInSeconds: Int, truncateHoursIfZero: Bool = false) -> String {
        let hours = timeInSeconds / 3600
        let minutes = timeInSeconds % 3600 / 60
        let seconds = timeInSeconds % 60
        if truncateHoursIfZero && hours == 0 {
            return String(format: "%02d:%02d", minutes, seconds)
        }
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    class func detailedString(from timeInSeconds: Int) -> String {
        let hours = timeInSeconds / 3600
        let minutes = timeInSeconds % 3600 / 60
        let seconds = timeInSeconds % 60
        if timeInSeconds == 0 {
            return String.localizedStringWithFormat(NSLocalizedString("%d seconds", comment: ""), seconds)
        } else {
            var resultString = ""
            resultString += hours > 0 ? String.localizedStringWithFormat(NSLocalizedString("%d hours ", comment: ""), hours) : ""
            resultString += minutes > 0 ? String.localizedStringWithFormat(NSLocalizedString("%d minutes ", comment: ""), minutes) : ""
            resultString += seconds > 0 ? String.localizedStringWithFormat(NSLocalizedString("%d seconds", comment: ""), seconds) : ""
            return resultString.trimmingCharacters(in: .whitespaces)
        }
    }
}
