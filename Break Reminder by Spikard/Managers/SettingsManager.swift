//
//  SettingsManager.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 26/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

let kMaxNumberOfShortBreaks = 10

enum NotificationType: Int {
    
    case no, sound, popup, popupAndSound
}

// MARK: - Setting

enum Setting: String {
    
    case sessionDuration
    case workIntervalDuration
    case longBreakDuration
    case numberOfShortBreaks
    case shortBreakDuration
    case isDisplayTimerOnStatusBar
    case notificationTypeBeforeLongBreak
    case beforeLongBreakSound
    case notifyTimeBeforeLongBreak
    case notificationTypeAfterLongBreak
    case afterLongBreakSound
    case notificationTypeBeforeShortBreak
    case beforeShortBreakSound
    case notifyTimeBeforeShortBreak
    case notificationTypeAfterShortBreak
    case afterShortBreakSound
    
    var `default`: Any {
        switch self {
        case .sessionDuration                   : return 28800
        case .workIntervalDuration              : return 3600
        case .longBreakDuration                 : return 300
        case .numberOfShortBreaks               : return 2
        case .shortBreakDuration                : return 60
        case .isDisplayTimerOnStatusBar         : return true
        case .notificationTypeBeforeLongBreak   : return NotificationType.popupAndSound
        case .beforeLongBreakSound              : return "Spikard 1"
        case .notifyTimeBeforeLongBreak         : return 300
        case .notificationTypeAfterLongBreak    : return NotificationType.sound
        case .afterLongBreakSound               : return "Spikard 2"
        case .notificationTypeBeforeShortBreak  : return NotificationType.popupAndSound
        case .beforeShortBreakSound             : return "Spikard 1"
        case .notifyTimeBeforeShortBreak        : return 120
        case .notificationTypeAfterShortBreak   : return NotificationType.sound
        case .afterShortBreakSound              : return "Spikard 2"
        }
    }
}

// MARK: - SettingsManager

final class SettingsManager {
    
    // MARK: - Public methods
    
    static func get(_ setting: Setting) -> Any {
        if setting == .notificationTypeBeforeLongBreak || setting == .notificationTypeAfterLongBreak || setting == .notificationTypeBeforeShortBreak || setting == .notificationTypeAfterShortBreak {
            return NotificationType(rawValue: UserDefaults.standard.value(forKey: setting.rawValue) as? Int ?? -1) ?? setting.default
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
