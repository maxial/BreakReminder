//
//  TimeConverter.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 27/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

final class TimeConverter {
    
    class func string(from timeInSeconds: Int) -> String {
        let hours = timeInSeconds / 3600
        let minutes = timeInSeconds % 3600 / 60
        let seconds = timeInSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
