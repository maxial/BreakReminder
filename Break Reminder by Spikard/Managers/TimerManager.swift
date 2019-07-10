//
//  TimerManager.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 26/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

let kTimeLeftInSecondsKey = "TimeLeftInSecondsKey"

enum Status: String {
    
    case workingTime, restTime
}

// MARK: - TimerManager

final class TimerManager {
    
    // MARK: - Public properties
    
    static let shared = TimerManager()
    
    private(set) var status: Status = .workingTime
    private(set) var timerIsPaused: Bool = false
    private(set) var timeLeftInSeconds = SettingsManager.timeInSeconds(for: .workingTime) { didSet { tick() } }
    
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
    
    // MARK: - Private methods
    
    private init() {
        timer = newTimer()
    }
    
    private func newTimer() -> Timer {
        let timer = Timer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        timer.tolerance = 0.15
        RunLoop.current.add(timer, forMode: .common)
        return timer
    }
    
    @objc private func fireTimer() {
        timeLeftInSeconds -= 1
    }
    
    private func tick() {
        if timeLeftInSeconds <= 0 {
            status = status == .restTime ? .workingTime : .restTime
            NotificationCenter.default.post(name: .timeIsUp, object: nil)
            startTimer()
        } else {
            NotificationCenter.default.post(name: .tick, object: nil, userInfo: [kTimeLeftInSecondsKey: timeLeftInSeconds])
        }
    }
}
