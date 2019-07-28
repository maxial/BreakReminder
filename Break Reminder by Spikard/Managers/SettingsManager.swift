//
//  SettingsManager.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 26/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

enum Status: String {
    
    case workingTime, restTime
}

enum Global: String {
    
    case totalWorkingTime
}

final class SettingsManager {
    
    // MARK: - Private properties
    
    private struct statusDefaults {
        static let workingTimeInSeconds = 3600
        static let restTimeInSeconds = 300
    }
    
    private struct globalDefaults {
        static let totalWorkingTimeInSeconds = 18000
    }
    
    // MARK: - Public methods
    
    class func timeInSeconds(for status: Status) -> Int {
        let timeInSeconds = UserDefaults.standard.integer(forKey: status.rawValue)
        return timeInSeconds > 0 ? timeInSeconds : defaultTimeInSeconds(for: status)
    }
    
    class func update(_ status: Status, withTimeInSeconds timeInSeconds: Int) {
        UserDefaults.standard.set(timeInSeconds, forKey: status.rawValue)
    }
    
    class func timeInSeconds(for global: Global) -> Int {
        let timeInSeconds = UserDefaults.standard.integer(forKey: global.rawValue)
        return timeInSeconds > 0 ? timeInSeconds : defaultTimeInSeconds(for: global)
    }
    
    class func update(_ global: Global, withTimeInSeconds timeInSeconds: Int) {
        UserDefaults.standard.set(timeInSeconds, forKey: global.rawValue)
    }
    
    // MARK: - Private methods
    
    private class func defaultTimeInSeconds(for status: Status) -> Int {
        switch status {
        case .workingTime: return statusDefaults.workingTimeInSeconds
        case .restTime:    return statusDefaults.restTimeInSeconds
        }
    }
    
    private class func defaultTimeInSeconds(for global: Global) -> Int {
        switch global {
        case .totalWorkingTime: return globalDefaults.totalWorkingTimeInSeconds
        }
    }
}
