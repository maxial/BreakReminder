//
//  TimerManager.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 26/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

private let kDefaultIdle = 30

enum Status {
    
    case work, shortBreak, longBreak
}

// MARK: - TimerManager

final class TimerManager {
    
    // MARK: - Public properties
    
    static let shared = TimerManager()
    
    var isPaused: Bool = false
    
    private(set) var status: Status = .work       { didSet { restartTimer() } }
    private(set) var timeLeftInSeconds = 0        { didSet { timerDidUpdate() } }
    private(set) var sessionTimeLeftInSeconds = 0 { didSet { sessionTimerDidUpdate() } }
    private(set) var currentShortBreak: Int = 0   { didSet { PopoverManager.shared.popoverViewController?.updateShortBreaksStackView() } }
    
    var timeIntervalInSeconds: Int {
        switch status {
        case .work       : return SettingsManager.getWorkIntervalDuration()
        case .shortBreak : return SettingsManager.get(.shortBreakDuration) as! Int
        case .longBreak  : return SettingsManager.get(.longBreakDuration) as! Int
        }
    }
    
    // MARK: - Private properties
    
    private var timer: Timer?
    private var notifiedThatBreakIsComingSoon: Bool = false
    private var skipNotification: Bool = false
    
    // MARK: - Public methods
    
    deinit {
        removeTimer()
    }
    
    func restartTimer() {
        timeLeftInSeconds = timeIntervalInSeconds
        notifiedThatBreakIsComingSoon = false
    }
    
    func restartSessionTimer() {
        sessionTimeLeftInSeconds = SettingsManager.get(.sessionDuration) as! Int
    }
    
    func skipBreak() {
        skipNotification = true
        timeLeftInSeconds = 0
    }
    
    func resetShortBreaks() {
        currentShortBreak = 0
    }
    
    // MARK: - Private methods
    
    private init() {
        timer = createTimer()
    }
    
    private func createTimer() -> Timer {
        let timer = Timer(timeInterval: 1.0, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        timer.tolerance = 0.15
        RunLoop.current.add(timer, forMode: .common)
        return timer
    }
    
    private func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func tick() {
        if sessionTimeLeftInSeconds > 0 { sessionTimeLeftInSeconds -= 1 }
        if !isPaused, timeLeftInSeconds > 0 { timeLeftInSeconds -= 1 }
    }
    
    private func timerDidUpdate() {
        if timeLeftInSeconds != timeIntervalInSeconds, status == .work {
            restartTimerIfUserWasInactive()
        }
        if !skipNotification {
            NotificationManager.shared.notifyIfNeeded()
        }
        skipNotification = false
        updateStatusIfTimeIsUp()
        PopoverManager.shared.popoverViewController?.timerDidUpdate()
        (NSApplication.shared.delegate as? AppDelegate)?.timerDidUpdate()
    }
    
    private func sessionTimerDidUpdate() {
        PopoverManager.shared.popoverViewController?.sessionTimerDidUpdate()
        (NSApplication.shared.delegate as? AppDelegate)?.sessionTimerDidUpdate()
    }
    
    private func restartTimerIfUserWasInactive() {
        let idleTime = Int(systemIdleTime() ?? 0) - kDefaultIdle
        let numberOfShortBreaks = SettingsManager.get(.numberOfShortBreaks) as! Int
        let isShortBreakNext = numberOfShortBreaks > 0 && currentShortBreak < numberOfShortBreaks
        let breakDuration = SettingsManager.get(isShortBreakNext ? .shortBreakDuration : .longBreakDuration) as! Int
        if idleTime > breakDuration {
            if Double(timeLeftInSeconds) < 0.1 * Double(timeIntervalInSeconds) && isShortBreakNext {
                currentShortBreak += 1
            }
            restartTimer()
        }
    }
    
    private func updateStatusIfTimeIsUp() {
        guard timeLeftInSeconds <= 0 else { return }
        
        switch status {
        case .work:
            currentShortBreak += 1
            if currentShortBreak > SettingsManager.get(.numberOfShortBreaks) as! Int {
                resetShortBreaks()
                status = .longBreak
            } else {
                status = .shortBreak
            }
        case .shortBreak, .longBreak:
            status = .work
        }
        
        (NSApplication.shared.delegate as? AppDelegate)?.timeIsUp()
    }
    
    private func systemIdleTime() -> Double? {
        var iterator: io_iterator_t = 0
        defer { IOObjectRelease(iterator) }
        let matchingDictionary = IOServiceMatching("IOHIDSystem")
        guard IOServiceGetMatchingServices(kIOMasterPortDefault, matchingDictionary, &iterator) == KERN_SUCCESS else { return nil }
        
        let entry: io_registry_entry_t = IOIteratorNext(iterator)
        defer { IOObjectRelease(entry) }
        guard entry != 0 else { return nil }
        
        var unmanagedDict: Unmanaged<CFMutableDictionary>? = nil
        defer { unmanagedDict?.release() }
        guard IORegistryEntryCreateCFProperties(entry, &unmanagedDict, kCFAllocatorDefault, 0) == KERN_SUCCESS else { return nil }
        guard let dict = unmanagedDict?.takeUnretainedValue() else { return nil }
        
        let key: CFString = "HIDIdleTime" as CFString
        let value = CFDictionaryGetValue(dict, Unmanaged.passUnretained(key).toOpaque())
        let number: CFNumber = unsafeBitCast(value, to: CFNumber.self)
        var nanoseconds: Int64 = 0
        guard CFNumberGetValue(number, CFNumberType.sInt64Type, &nanoseconds) else { return nil }
        let interval = Double(nanoseconds) / Double(NSEC_PER_SEC)
        
        return interval
    }
}
