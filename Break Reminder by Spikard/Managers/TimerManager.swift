//
//  TimerManager.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 26/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

// MARK: - TimerManager

final class TimerManager {
    
    // MARK: - Public properties
    
    static let shared = TimerManager()
    
    private(set) var status: Status = .workingTime
    private(set) var timerIsPaused: Bool = false
    private(set) var timeLeftInSeconds = SettingsManager.timeInSeconds(for: .workingTime) { didSet { tickDidHappen() } }
    private(set) var totalTimeLeftInSeconds = SettingsManager.timeInSeconds(for: .totalWorkingTime)
    
    // MARK: - Private properties
    
    private var timer: Timer?
    
    // MARK: - Public methods
    
    deinit {
        guard let timer = timer else { return }
        timer.invalidate()
        self.timer = nil
    }
    
    func startTimer() {
        timeLeftInSeconds = SettingsManager.timeInSeconds(for: status)
    }
    
    func toggleTimer() {
        if timerIsPaused {
            timer = newTimer()
        } else {
            timer?.invalidate()
        }
        timerIsPaused = !timerIsPaused
    }
    
    func skipRestTime() {
        timeLeftInSeconds = 0
    }
    
    func restartTotalTimer() {
        totalTimeLeftInSeconds = SettingsManager.timeInSeconds(for: .totalWorkingTime)
    }
    
    // MARK: - Private methods
    
    private init() {
        timer = newTimer()
    }
    
    private func newTimer() -> Timer {
        let timer = Timer(timeInterval: 1.0, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        timer.tolerance = 0.15
        RunLoop.current.add(timer, forMode: .common)
        return timer
    }
    
    @objc private func tick() {
        totalTimeLeftInSeconds -= 1
        if Int(systemIdleTime() ?? 0) >= SettingsManager.timeInSeconds(for: .restTime) {
            timeLeftInSeconds = SettingsManager.timeInSeconds(for: .workingTime)
        } else {
            timeLeftInSeconds -= 1
        }
    }
    
    private func tickDidHappen() {
        NotificationCenter.default.post(name: .tick, object: nil)
        if timeLeftInSeconds <= 0 {
            status = status == .restTime ? .workingTime : .restTime
            NotificationCenter.default.post(name: .timeIsUp, object: nil)
            startTimer()
        }
        if totalTimeLeftInSeconds <= 0 {
            NotificationCenter.default.post(name: .totalTimeIsUp, object: nil)
        }
    }
    
    private func systemIdleTime() -> Double? {
        var iterator: io_iterator_t = 0
        defer { IOObjectRelease(iterator) }
        guard IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceMatching("IOHIDSystem"), &iterator) == KERN_SUCCESS else { return nil }
        
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
