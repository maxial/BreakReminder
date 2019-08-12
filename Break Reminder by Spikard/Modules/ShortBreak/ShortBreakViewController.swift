//
//  ShortBreakViewController.swift
//  Break Reminder by Spikard
//
//  Created by maxial on 09/08/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

// MARK: - ShortBreakViewController

final class ShortBreakViewController: NSViewController {
    
    // MARK: - Private properties
    
    @IBOutlet private weak var messageLabel: NSTextField!
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
        let percentage = 1 - Double(TimerManager.shared.timeLeftInSeconds) / Double(SettingsManager.get(.shortBreakDuration) as! Int)
        progressIndicator.doubleValue = percentage
        pastTimeLabel.stringValue = TimeConverter.string(from: SettingsManager.get(.shortBreakDuration) as! Int - TimerManager.shared.timeLeftInSeconds)
        leftTimeLabel.stringValue = "-" + TimeConverter.string(from: TimerManager.shared.timeLeftInSeconds)
    }
    
    // MARK: - Private methods
    
    @IBAction private func skipButtonClicked(_ sender: Any) {
        TimerManager.shared.skipBreak()
    }
}
