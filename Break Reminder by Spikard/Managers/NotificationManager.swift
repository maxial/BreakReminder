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
    
    private var notifiedBeforeBreak = false
    private var notifiedAfterBreak = false
    
    // MARK: - Public properties
    
    func notifyIfNeeded() {
        switch TimerManager.shared.status {
        case .work:
            guard !notifiedBeforeBreak else { return }
            let isLongBreak = TimerManager.shared.currentShortBreak == (SettingsManager.get(.numberOfShortBreaks) as! Int)
            let notificationType = SettingsManager.get(isLongBreak ? .notificationTypeBeforeLongBreak : .notificationTypeBeforeShortBreak) as! NotificationType
            let timeBeforeBreak = SettingsManager.get(isLongBreak ? .notifyTimeBeforeLongBreak : .notifyTimeBeforeShortBreak) as! Int
            guard TimerManager.shared.timeLeftInSeconds <= timeBeforeBreak else { return }
            notifyBeforeBreakIfNeeded(with: notificationType, isLongBreak: isLongBreak)
        case .shortBreak:
            guard TimerManager.shared.timeLeftInSeconds == 0 else { return }
            let notificationType = SettingsManager.get(.notificationTypeAfterShortBreak) as! NotificationType
            notifyAfterBreak(with: notificationType, isLongBreak: false)
        case .longBreak:
            guard TimerManager.shared.timeLeftInSeconds == 0 else { return }
            let notificationType = SettingsManager.get(.notificationTypeAfterLongBreak) as! NotificationType
            notifyAfterBreak(with: notificationType, isLongBreak: true)
        }
    }
    
    func reset() {
        notifiedBeforeBreak = false
    }
    
    // MARK: - Private methods
    
    private override init() {
        super.init()
        NSUserNotificationCenter.default.delegate = self
    }
    
    private func notifyBeforeBreakIfNeeded(with notificationType: NotificationType, isLongBreak: Bool) {
        guard notificationType != .no else { return }
        notifiedBeforeBreak = true
        if notificationType == .popupAndSound || notificationType == .sound {
            let soundName = SettingsManager.get(isLongBreak ? .beforeLongBreakSound : .beforeShortBreakSound) as! String
            playSound(named: soundName)
        }
        if notificationType == .popupAndSound || notificationType == .popup {
            let notification = NSUserNotification()
            notification.identifier = UUID().uuidString
            notification.title = "Break Reminder by Spikard"
            let timeLeftInSeconds = TimerManager.shared.timeLeftInSeconds
            notification.subtitle = TimeConverter.detailedString(from: timeLeftInSeconds) + NSLocalizedString(" left before the break", comment: "")
            notification.soundName = nil
            NSUserNotificationCenter.default.deliver(notification)
        }
    }
    
    private func notifyAfterBreak(with notificationType: NotificationType, isLongBreak: Bool) {
        guard notificationType == .popupAndSound || notificationType == .sound else { return }
        let soundName = SettingsManager.get(isLongBreak ? .afterLongBreakSound : .afterShortBreakSound) as! String
        playSound(named: soundName)
    }
    
    private func playSound(named soundName: String) {
        let soundUrl = Bundle.main.url(forResource: soundName, withExtension: "wav")
        let sound = soundUrl == nil ? NSSound(named: NSSound.Name(soundName)) : NSSound(contentsOf: soundUrl!, byReference: true)
        sound?.play()
    }
}

// MARK: - NSUserNotificationCenterDelegate

extension NotificationManager: NSUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
}
