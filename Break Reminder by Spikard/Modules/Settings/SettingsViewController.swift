//
//  SettingsViewController.swift
//  Break Reminder by Spikard
//
//  Created by maxial on 27/07/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

// MARK: - SettingsViewController

final class SettingsViewController: NSViewController {
    
    // MARK: - Private properties
    
    @IBOutlet private weak var totalWorkingTimePopUpButton: NSPopUpButton!
    @IBOutlet private weak var workIntervalDurationPopUpButton: NSPopUpButton!
    @IBOutlet private weak var longBreakDurationPopUpButton: NSPopUpButton!
    @IBOutlet private weak var launchAtSystemStartupButton: NSButton!
    
    @IBOutlet private weak var enableShortBreaksButton: NSButton!
    @IBOutlet private weak var shortBreakDurationPopUpButton: NSPopUpButton!
    @IBOutlet private weak var numberOfShortBreaksStepper: NSStepper!
    @IBOutlet private weak var numberOfShortBreaksTextField: NSTextField!
    
    @IBOutlet private weak var shortBreakDurationView: NSView!
    @IBOutlet private weak var numberOfShortBreaksView: NSView!
    
    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        #if DEBUG
//
//        totalWorkingTimePopUpButton.insertItem(withTitle: "5 sec", at: 0)
//        totalWorkingTimePopUpButton.item(at: 0)?.tag = 5
//
//        workIntervalDurationPopUpButton.insertItem(withTitle: "1 min", at: 0)
//        workIntervalDurationPopUpButton.item(at: 0)?.tag = 60
//
//        shortBreakDurationPopUpButton.insertItem(withTitle: "2 sec", at: 0)
//        shortBreakDurationPopUpButton.item(at: 0)?.tag = 2
//
//        #endif
        
        setup()
        updateUI()
    }
    
    // MARK: - Private methods
    
    private func setup() {
        let totalWorkingTimeInSeconds = SettingsManager.get(.sessionDuration) as! Int
        let workIntervalDurationInSeconds = SettingsManager.get(.workIntervalDuration) as! Int
        let longBreakDurationInSeconds = SettingsManager.get(.longBreakDuration) as! Int
        
        totalWorkingTimePopUpButton.selectItem(withTag: totalWorkingTimeInSeconds)
        workIntervalDurationPopUpButton.selectItem(withTag: workIntervalDurationInSeconds)
        longBreakDurationPopUpButton.selectItem(withTag: longBreakDurationInSeconds)
        launchAtSystemStartupButton.state = StartupManager.startAppOnSystemStartup ? .on : .off
        
        let shortBreakDurationInSeconds = SettingsManager.get(.shortBreakDuration) as! Int
        let numberOfShortBreaks = SettingsManager.get(.numberOfShortBreaks) as! Int
        
        enableShortBreaksButton.state = SettingsManager.get(.isEnabledShortBreaks) as! Bool ? .on : .off
        shortBreakDurationPopUpButton.selectItem(withTag: shortBreakDurationInSeconds)
        numberOfShortBreaksStepper.integerValue = numberOfShortBreaks
        numberOfShortBreaksTextField.stringValue = "\(numberOfShortBreaks)"
        
        numberOfShortBreaksStepper.maxValue = Double(kMaxNumberOfShortBreaks)
        numberOfShortBreaksStepper.minValue = 1
    }
    
    private func updateUI() {
        let isEnabledShortBreaks = enableShortBreaksButton.state == .on
        shortBreakDurationView.isHidden = !isEnabledShortBreaks
        numberOfShortBreaksView.isHidden = !isEnabledShortBreaks
    }
    
    @IBAction private func totalWorkingTimeChanged(_ sender: NSPopUpButton) {
        SettingsManager.set(sender.selectedItem?.tag ?? 0, for: .sessionDuration)
        TimerManager.shared.restartSessionTimer()
    }
    
    @IBAction private func workIntervalDurationChanged(_ sender: NSPopUpButton) {
        SettingsManager.set(sender.selectedItem?.tag ?? 0, for: .workIntervalDuration)
        if TimerManager.shared.status == .work {
            TimerManager.shared.restartTimer()
        }
    }
    
    @IBAction private func longBreakDurationChanged(_ sender: NSPopUpButton) {
        SettingsManager.set(sender.selectedItem?.tag ?? 0, for: .longBreakDuration)
        if TimerManager.shared.status == .longBreak {
            TimerManager.shared.restartTimer()
        }
    }
    
    @IBAction private func enableShortBreaksChanged(_ sender: NSButton) {
        SettingsManager.set(sender.state == .on, for: .isEnabledShortBreaks)
        updateUI()
        TimerManager.shared.resetShortBreaks()
        TimerManager.shared.restartTimer()
        PopoverManager.shared.popoverViewController?.updateShortBreaksStackView()
    }
    
    @IBAction private func shortBreakDurationChanged(_ sender: NSPopUpButton) {
        SettingsManager.set(sender.selectedItem?.tag ?? 0, for: .shortBreakDuration)
        if TimerManager.shared.status == .shortBreak {
            TimerManager.shared.restartTimer()
        }
    }
    
    @IBAction private func numberOfShortBreaksChanged(_ sender: NSStepper) {
        guard SettingsManager.get(.numberOfShortBreaks) as! Int != sender.integerValue else { return }
        numberOfShortBreaksTextField.stringValue = "\(sender.integerValue)"
        SettingsManager.set(sender.integerValue, for: .numberOfShortBreaks)
        PopoverManager.shared.popoverViewController?.updateShortBreaksStackView()
        if TimerManager.shared.status == .work {
            TimerManager.shared.restartTimer()
        }
    }
    
    @IBAction private func launchAtSystemStartupChanged(_ sender: NSButton) {
        StartupManager.startAppOnSystemStartup = sender.state == .on
    }
}
