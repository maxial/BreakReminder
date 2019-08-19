//
//  NotificationManager.swift
//  Break Reminder by Spikard
//
//  Created by maxial on 18/08/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

// MARK: - NotificationManager

final class NotificationManager: NSObject {
    
    static let shared = NotificationManager()
    
    // MARK: - Private properties
    
    private var notifiedThatBreakIsComingSoon = false
    
    // MARK: - Public properties
    
    func notifyIfNeeded() {
        switch TimerManager.shared.status {
        case .work:
            guard !notifiedThatBreakIsComingSoon else { return }
            let isLongBreak = TimerManager.shared.currentShortBreak == (SettingsManager.get(.numberOfShortBreaks) as! Int)
            let notifySetting = SettingsManager.get(isLongBreak ? .notifyBeforeLongBreak : .notifyBeforeShortBreak) as! NotifySetting
            let timeBeforeBreak = SettingsManager.get(isLongBreak ? .notifyTimeBeforeLongBreak : .notifyTimeBeforeShortBreak) as! Int
            if notifySetting != .no, TimerManager.shared.timeLeftInSeconds <= timeBeforeBreak {
                notifyBeforeBreak(soundOnly: notifySetting == .soundOnly)
            }
        case .shortBreak:
            guard (SettingsManager.get(.notifyAfterShortBreak) as! NotifySetting) == .soundOnly, TimerManager.shared.timeLeftInSeconds == 0 else { break }
            notifyAfterBreakWithSoundOnly()
        case .longBreak:
            guard (SettingsManager.get(.notifyAfterLongBreak) as! NotifySetting) == .soundOnly, TimerManager.shared.timeLeftInSeconds == 0 else { break }
            notifyAfterBreakWithSoundOnly()
        }
    }
    
    // MARK: - Private methods
    
    private override init() {
        super.init()
        NSUserNotificationCenter.default.delegate = self
    }
    
    private func notifyBeforeBreak(soundOnly: Bool) {
        notifiedThatBreakIsComingSoon = true
        NSSound(contentsOf: Bundle.main.url(forResource: "BeforeBreak", withExtension: "wav")!, byReference: true)?.play()
        guard !soundOnly else { return }
        let notification = NSUserNotification()
        notification.identifier = UUID().uuidString
        notification.title = "Break Reminder by Spikard"
        let timeLeftInSeconds = TimerManager.shared.timeLeftInSeconds
        notification.subtitle = TimeConverter.detailedString(from: timeLeftInSeconds) + NSLocalizedString(" left before the break", comment: "")
        notification.soundName = nil
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    private func notifyAfterBreakWithSoundOnly() {
        NSSound(contentsOf: Bundle.main.url(forResource: "AfterBreak", withExtension: "wav")!, byReference: true)?.play()
    }
}

// MARK: - NSUserNotificationCenterDelegate

extension NotificationManager: NSUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
}
