//
//  NotificationsSettingsViewController.swift
//  Break Reminder by Spikard
//
//  Created by maxial on 17/08/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

// MARK: - NotificationsSettingsViewController

final class NotificationsSettingsViewController: NSViewController {
    
    // MARK: - Private properties
    
    @IBOutlet private weak var notifyBeforeLongBreakYesButton: NSButton!
    @IBOutlet private weak var notifyBeforeLongBreakSoundOnlyButton: NSButton!
    @IBOutlet private weak var notifyBeforeLongBreakNoButton: NSButton!
    @IBOutlet private weak var timeBeforeLongBreakPopUpButton: NSPopUpButton!
    @IBOutlet private weak var notifyAfterLongBreakSoundOnlyButton: NSButton!
    @IBOutlet private weak var notifyAfterLongBreakNoButton: NSButton!
    
    @IBOutlet private weak var notifyBeforeShortBreakYesButton: NSButton!
    @IBOutlet private weak var notifyBeforeShortBreakSoundOnlyButton: NSButton!
    @IBOutlet private weak var notifyBeforeShortBreakNoButton: NSButton!
    @IBOutlet private weak var timeBeforeShortBreakPopUpButton: NSPopUpButton!
    @IBOutlet private weak var notifyAfterShortBreakSoundOnlyButton: NSButton!
    @IBOutlet private weak var notifyAfterShortBreakNoButton: NSButton!
    
    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Private methods
    
    private func setup() {
        let timeBeforeLongBreak = SettingsManager.get(.notifyTimeBeforeLongBreak) as! Int
        let timeBeforeShortBreak = SettingsManager.get(.notifyTimeBeforeShortBreak) as! Int
        
        updateNotifyBeforeLongBreak()
        timeBeforeLongBreakPopUpButton.selectItem(withTag: timeBeforeLongBreak)
        updateNotifyAfterLongBreak()
        updateNotifyBeforeShortBreak()
        timeBeforeShortBreakPopUpButton.selectItem(withTag: timeBeforeShortBreak)
        updateNotifyAfterShortBreak()
    }
    
    @IBAction private func notifyBeforeLongBreakOptionChanged(_ sender: NSButton) {
        SettingsManager.set(sender.tag, for: .notifyBeforeLongBreak)
        updateNotifyBeforeLongBreak()
    }
    
    @IBAction private func timeBeforeLongBreakChanged(_ sender: NSPopUpButton) {
        SettingsManager.set(sender.selectedItem?.tag ?? 0, for: .notifyTimeBeforeLongBreak)
    }
    
    @IBAction private func notifyAfterLongBreakOptionChanged(_ sender: NSButton) {
        SettingsManager.set(sender.tag, for: .notifyAfterLongBreak)
        updateNotifyAfterLongBreak()
    }
    
    @IBAction private func notifyBeforeShortBreakOptionChanged(_ sender: NSButton) {
        SettingsManager.set(sender.tag, for: .notifyBeforeShortBreak)
        updateNotifyBeforeShortBreak()
    }
    
    @IBAction private func timeBeforeShortBreakChanged(_ sender: NSPopUpButton) {
        SettingsManager.set(sender.selectedItem?.tag ?? 0, for: .notifyTimeBeforeShortBreak)
    }
    
    @IBAction private func notifyAfterShortBreakOptionChanged(_ sender: NSButton) {
        SettingsManager.set(sender.tag, for: .notifyAfterShortBreak)
        updateNotifyAfterShortBreak()
    }
    
    private func updateNotifyBeforeLongBreak() {
        let notifyBeforeLongBreakOption = SettingsManager.get(.notifyBeforeLongBreak) as! NotifySetting
        switch notifyBeforeLongBreakOption {
        case .yes:
            notifyBeforeLongBreakYesButton.state = .on
            notifyBeforeLongBreakSoundOnlyButton.state = .off
            notifyBeforeLongBreakNoButton.state = .off
        case .soundOnly:
            notifyBeforeLongBreakYesButton.state = .off
            notifyBeforeLongBreakSoundOnlyButton.state = .on
            notifyBeforeLongBreakNoButton.state = .off
        case .no:
            notifyBeforeLongBreakYesButton.state = .off
            notifyBeforeLongBreakSoundOnlyButton.state = .off
            notifyBeforeLongBreakNoButton.state = .on
        }
    }
    
    private func updateNotifyAfterLongBreak() {
        let notifyAfterLongBreakOption = SettingsManager.get(.notifyAfterLongBreak) as! NotifySetting
        switch notifyAfterLongBreakOption {
        case .yes:
            notifyAfterLongBreakSoundOnlyButton.state = .off
            notifyAfterLongBreakNoButton.state = .off
        case .soundOnly:
            notifyAfterLongBreakSoundOnlyButton.state = .on
            notifyAfterLongBreakNoButton.state = .off
        case .no:
            notifyAfterLongBreakSoundOnlyButton.state = .off
            notifyAfterLongBreakNoButton.state = .on
        }
    }
    
    private func updateNotifyBeforeShortBreak() {
        let notifyBeforeShortBreakOption = SettingsManager.get(.notifyBeforeShortBreak) as! NotifySetting
        switch notifyBeforeShortBreakOption {
        case .yes:
            notifyBeforeShortBreakYesButton.state = .on
            notifyBeforeShortBreakSoundOnlyButton.state = .off
            notifyBeforeShortBreakNoButton.state = .off
        case .soundOnly:
            notifyBeforeShortBreakYesButton.state = .off
            notifyBeforeShortBreakSoundOnlyButton.state = .on
            notifyBeforeShortBreakNoButton.state = .off
        case .no:
            notifyBeforeShortBreakYesButton.state = .off
            notifyBeforeShortBreakSoundOnlyButton.state = .off
            notifyBeforeShortBreakNoButton.state = .on
        }
    }
    
    private func updateNotifyAfterShortBreak() {
        let notifyAfterShortBreakOption = SettingsManager.get(.notifyAfterShortBreak) as! NotifySetting
        switch notifyAfterShortBreakOption {
        case .yes:
            notifyAfterShortBreakSoundOnlyButton.state = .off
            notifyAfterShortBreakNoButton.state = .off
        case .soundOnly:
            notifyAfterShortBreakSoundOnlyButton.state = .on
            notifyAfterShortBreakNoButton.state = .off
        case .no:
            notifyAfterShortBreakSoundOnlyButton.state = .off
            notifyAfterShortBreakNoButton.state = .on
        }
    }
}
