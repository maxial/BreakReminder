//
//  GeneralSettingsViewController.swift
//  Break Reminder by Spikard
//
//  Created by maxial on 17/08/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

// MARK: - GeneralSettingsViewController

final class GeneralSettingsViewController: NSViewController {
    
    // MARK: - Private properties
    
    @IBOutlet private weak var totalWorkingTimePopUpButton: NSPopUpButton!
    @IBOutlet private weak var workIntervalDurationPopUpButton: NSPopUpButton!
    @IBOutlet private weak var longBreakDurationPopUpButton: NSPopUpButton!
    @IBOutlet private weak var numberOfShortBreaksPopUpButton: NSPopUpButton!
    @IBOutlet private weak var shortBreakDurationPopUpButton: NSPopUpButton!
    @IBOutlet private weak var launchAtSystemStartupButton: NSButton!
    @IBOutlet private weak var displayTimerOnStatusBarButton: NSButton!
    
    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        updateUI()
    }
    
    private func setup() {
        let totalWorkingTimeInSeconds = SettingsManager.get(.sessionDuration) as! Int
        let workIntervalDurationInSeconds = SettingsManager.get(.workIntervalDuration) as! Int
        let longBreakDurationInSeconds = SettingsManager.get(.longBreakDuration) as! Int
        let numberOfShortBreaks = SettingsManager.get(.numberOfShortBreaks) as! Int
        let shortBreakDurationInSeconds = SettingsManager.get(.shortBreakDuration) as! Int
        
        totalWorkingTimePopUpButton.selectItem(withTag: totalWorkingTimeInSeconds)
        workIntervalDurationPopUpButton.selectItem(withTag: workIntervalDurationInSeconds)
        longBreakDurationPopUpButton.selectItem(withTag: longBreakDurationInSeconds)
        numberOfShortBreaksPopUpButton.selectItem(withTag: numberOfShortBreaks)
        shortBreakDurationPopUpButton.selectItem(withTag: shortBreakDurationInSeconds)
        launchAtSystemStartupButton.state = StartupManager.startAppOnSystemStartup ? .on : .off
        displayTimerOnStatusBarButton.state = SettingsManager.get(.isDisplayTimerOnStatusBar) as! Bool ? .on : .off
    }
    
    private func updateUI() {
        let numberOfShortBreaks = SettingsManager.get(.numberOfShortBreaks) as! Int
        shortBreakDurationPopUpButton.isEnabled = numberOfShortBreaks > 0
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
    
    @IBAction private func numberOfShortBreaksChanged(_ sender: NSPopUpButton) {
        SettingsManager.set(sender.selectedItem?.tag ?? 0, for: .numberOfShortBreaks)
        PopoverManager.shared.popoverViewController?.updateShortBreaksStackView()
        if TimerManager.shared.status == .work {
            TimerManager.shared.restartTimer()
        }
        updateUI()
    }
    
    @IBAction private func shortBreakDurationChanged(_ sender: NSPopUpButton) {
        SettingsManager.set(sender.selectedItem?.tag ?? 0, for: .shortBreakDuration)
        if TimerManager.shared.status == .shortBreak {
            TimerManager.shared.restartTimer()
        }
    }
    
    @IBAction private func launchAtSystemStartupChanged(_ sender: NSButton) {
        StartupManager.startAppOnSystemStartup = sender.state == .on
    }
    
    @IBAction private func displayTimerOnStatusBarChanged(_ sender: NSButton) {
        SettingsManager.set(sender.state == .on, for: .isDisplayTimerOnStatusBar)
        (NSApplication.shared.delegate as? AppDelegate)?.updateStatusItemTimer()
    }
}
