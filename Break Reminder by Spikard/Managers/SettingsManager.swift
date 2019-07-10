//
//  SettingsManager.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 26/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

final class SettingsManager {
    
    // MARK: - Private properties
    
    private struct defaults {
        static let workingTimeInSeconds = 3600
        static let restTimeInSeconds = 300
    }
    
    // MARK: - Public methods
    
    class func timeInSeconds(for status: Status) -> Int {
        let timeInSeconds = UserDefaults.standard.integer(forKey: status.rawValue)
        return timeInSeconds > 0 ? timeInSeconds : defaultTimeInSeconds(for: status)
    }
    
    class func update(_ status: Status, withTimeInSeconds timeInSeconds: Int) {
        UserDefaults.standard.set(timeInSeconds, forKey: status.rawValue)
        if TimerManager.shared.status == status {
            TimerManager.shared.startTimer()
        }
    }
    
    // MARK: - Private methods
    
    private class func defaultTimeInSeconds(for status: Status) -> Int {
        switch status {
        case .workingTime:  return defaults.workingTimeInSeconds
        case .restTime:     return defaults.restTimeInSeconds
        }
    }
}
