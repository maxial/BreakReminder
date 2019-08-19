//
//  SettingsManager.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 26/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

let kMaxNumberOfShortBreaks = 10

enum NotifySetting: Int {
    
    case yes = 2, soundOnly = 1, no = 0
}

// MARK: - Setting

enum Setting: String {
    
    case sessionDuration
    case workIntervalDuration
    case longBreakDuration
    case numberOfShortBreaks
    case shortBreakDuration
    case isDisplayTimerOnStatusBar
    case notifyBeforeLongBreak
    case notifyTimeBeforeLongBreak
    case notifyAfterLongBreak
    case notifyBeforeShortBreak
    case notifyTimeBeforeShortBreak
    case notifyAfterShortBreak
    
    var `default`: Any {
        switch self {
        case .sessionDuration           : return 28800
        case .workIntervalDuration      : return 3600
        case .longBreakDuration         : return 300
        case .numberOfShortBreaks       : return 2
        case .shortBreakDuration        : return 60
        case .isDisplayTimerOnStatusBar : return true
        case .notifyBeforeLongBreak     : return NotifySetting.yes
        case .notifyTimeBeforeLongBreak : return 300
        case .notifyAfterLongBreak      : return NotifySetting.soundOnly
        case .notifyBeforeShortBreak    : return NotifySetting.yes
        case .notifyTimeBeforeShortBreak: return 120
        case .notifyAfterShortBreak     : return NotifySetting.soundOnly
        }
    }
}

// MARK: - SettingsManager

final class SettingsManager {
    
    // MARK: - Public methods
    
    static func get(_ setting: Setting) -> Any {
        if setting == .notifyBeforeLongBreak || setting == .notifyAfterLongBreak || setting == .notifyBeforeShortBreak || setting == .notifyAfterShortBreak {
            return NotifySetting(rawValue: UserDefaults.standard.value(forKey: setting.rawValue) as? Int ?? -1) ?? setting.default
        }
        return UserDefaults.standard.value(forKey: setting.rawValue) ?? setting.default
    }
    
    static func set(_ value: Any, for setting: Setting) {
        UserDefaults.standard.set(value, forKey: setting.rawValue)
    }
    
    static func getWorkIntervalDuration() -> Int {
        let numberOfShortBreaks = SettingsManager.get(.numberOfShortBreaks) as! Int
        let workIntervalDuration = SettingsManager.get(.workIntervalDuration) as! Int
        return workIntervalDuration / (numberOfShortBreaks + 1)
    }
}
