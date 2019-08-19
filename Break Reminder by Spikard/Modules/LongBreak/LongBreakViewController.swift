//
//  LongBreakViewController.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 26/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

// MARK: - LongBreakViewController

final class LongBreakViewController: NSViewController {
    
    // MARK: - Private properties
    
    @IBOutlet private weak var progressIndicator: NSProgressIndicator!
    @IBOutlet private weak var pastTimeLabel: NSTextField!
    @IBOutlet private weak var leftTimeLabel: NSTextField!
    
    // MARK: - Public methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pastTimeLabel.font = .breakTimerMonospacedDigitSystemFont
        leftTimeLabel.font = .breakTimerMonospacedDigitSystemFont
        
        timerDidUpdate()
    }
    
    func timerDidUpdate() {
        let percentage = 1 - Double(TimerManager.shared.timeLeftInSeconds) / Double(SettingsManager.get(.longBreakDuration) as! Int)
        progressIndicator.doubleValue = percentage
        pastTimeLabel.stringValue = TimeConverter.timerString(from: SettingsManager.get(.longBreakDuration) as! Int - TimerManager.shared.timeLeftInSeconds)
        leftTimeLabel.stringValue = "-" + TimeConverter.timerString(from: TimerManager.shared.timeLeftInSeconds)
    }
    
    // MARK: - Private methods
    
    @IBAction private func skipButtonClicked(_ sender: Any) {
        TimerManager.shared.skipBreak()
    }
}
