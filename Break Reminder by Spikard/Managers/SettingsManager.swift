//
//  SettingsManager.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 26/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

let kMaxNumberOfShortBreaks = 10

// MARK: - Setting

enum Setting: String {
    
    case sessionDuration
    case workIntervalDuration
    case longBreakDuration
    case shortBreakDuration
    case numberOfShortBreaks
    case isEnabledShortBreaks
    
    var `default`: Any {
        switch self {
        case .sessionDuration       : return 28800
        case .workIntervalDuration  : return 3600
        case .longBreakDuration     : return 300
        case .shortBreakDuration    : return 60
        case .numberOfShortBreaks   : return 2
        case .isEnabledShortBreaks  : return true
        }
    }
}

// MARK: - SettingsManager

final class SettingsManager {
    
    // MARK: - Public methods
    
    static func get(_ setting: Setting) -> Any {
        return UserDefaults.standard.value(forKey: setting.rawValue) ?? setting.default
    }
    
    static func set(_ value: Any, for setting: Setting) {
        UserDefaults.standard.set(value, forKey: setting.rawValue)
    }
    
    static func getWorkIntervalDuration() -> Int {
        let isEnabledShortBreaks = SettingsManager.get(.isEnabledShortBreaks) as! Bool
        let workIntervalDuration = SettingsManager.get(.workIntervalDuration) as! Int
        if isEnabledShortBreaks {
            let numberOfShortBreaks = SettingsManager.get(.numberOfShortBreaks) as! Int
            return workIntervalDuration / (numberOfShortBreaks + 1)
        } else {
            return workIntervalDuration
        }
    }
}
