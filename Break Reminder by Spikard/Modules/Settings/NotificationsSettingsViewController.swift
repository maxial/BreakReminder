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
    
    @IBOutlet private weak var notifyBeforeLongBreakPopupButton: NSButton!
    @IBOutlet private weak var notifyBeforeLongBreakSoundButton: NSButton!
    @IBOutlet private weak var timeBeforeLongBreakPopUpButton: NSPopUpButton!
    @IBOutlet private weak var beforeLongBreakSoundPopUpButton: NSPopUpButton!
    
    @IBOutlet private weak var notifyAfterLongBreakSoundButton: NSButton!
    @IBOutlet private weak var afterLongBreakSoundPopUpButton: NSPopUpButton!
    
    @IBOutlet private weak var notifyBeforeShortBreakPopupButton: NSButton!
    @IBOutlet private weak var notifyBeforeShortBreakSoundButton: NSButton!
    @IBOutlet private weak var timeBeforeShortBreakPopUpButton: NSPopUpButton!
    @IBOutlet private weak var beforeShortBreakSoundPopUpButton: NSPopUpButton!
    
    @IBOutlet private weak var notifyAfterShortBreakSoundButton: NSButton!
    @IBOutlet private weak var afterShortBreakSoundPopUpButton: NSPopUpButton!
    
    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Private methods
    
    private func setup() {
        setupSounds()
        updateNotificationStatusBeforeLongBreak()
        updateNotificationStatusAfterLongBreak()
        updateNotificationStatusBeforeShortBreak()
        updateNotificationStatusAfterShortBreak()
    }
    
    @IBAction private func notifyBeforeLongBreakOptionChanged(_ sender: NSButton) {
        update(setting: .notificationTypeBeforeLongBreak, popup: notifyBeforeLongBreakPopupButton.state == .on, sound: notifyBeforeLongBreakSoundButton.state == .on)
    }
    
    @IBAction private func timeBeforeLongBreakChanged(_ sender: NSPopUpButton) {
        SettingsManager.set(sender.selectedItem?.tag ?? 0, for: .notifyTimeBeforeLongBreak)
    }
    
    @IBAction private func notifyAfterLongBreakOptionChanged(_ sender: NSButton) {
        update(setting: .notificationTypeAfterLongBreak, popup: false, sound: notifyAfterLongBreakSoundButton.state == .on)
    }
    
    @IBAction private func notifyBeforeShortBreakOptionChanged(_ sender: NSButton) {
        update(setting: .notificationTypeBeforeShortBreak, popup: notifyBeforeShortBreakPopupButton.state == .on, sound: notifyBeforeShortBreakSoundButton.state == .on)
    }
    
    @IBAction private func timeBeforeShortBreakChanged(_ sender: NSPopUpButton) {
        SettingsManager.set(sender.selectedItem?.tag ?? 0, for: .notifyTimeBeforeShortBreak)
    }
    
    @IBAction private func notifyAfterShortBreakOptionChanged(_ sender: NSButton) {
        update(setting: .notificationTypeAfterShortBreak, popup: false, sound: notifyAfterShortBreakSoundButton.state == .on)
    }
    
    @IBAction private func notificationSoundChanged(_ sender: NSPopUpButton) {
        guard let sound = sender.selectedItem?.title else { return }
        NSSound(named: NSSound.Name(sound))?.play()
        switch sender {
        case beforeLongBreakSoundPopUpButton    : SettingsManager.set(sound, for: .beforeLongBreakSound)
        case afterLongBreakSoundPopUpButton     : SettingsManager.set(sound, for: .afterLongBreakSound)
        case beforeShortBreakSoundPopUpButton   : SettingsManager.set(sound, for: .beforeShortBreakSound)
        case afterShortBreakSoundPopUpButton    : SettingsManager.set(sound, for: .afterShortBreakSound)
        default: break
        }
    }
    
    private func setupSounds() {
        for sound in SystemSounds.allCases {
            beforeLongBreakSoundPopUpButton.addItem(withTitle: sound.rawValue)
            afterLongBreakSoundPopUpButton.addItem(withTitle: sound.rawValue)
            beforeShortBreakSoundPopUpButton.addItem(withTitle: sound.rawValue)
            afterShortBreakSoundPopUpButton.addItem(withTitle: sound.rawValue)
        }
        beforeLongBreakSoundPopUpButton.selectItem(withTitle: SettingsManager.get(.beforeLongBreakSound) as! String)
        afterLongBreakSoundPopUpButton.selectItem(withTitle: SettingsManager.get(.afterLongBreakSound) as! String)
        beforeShortBreakSoundPopUpButton.selectItem(withTitle: SettingsManager.get(.beforeShortBreakSound) as! String)
        afterShortBreakSoundPopUpButton.selectItem(withTitle: SettingsManager.get(.afterShortBreakSound) as! String)
    }
    
    private func updateNotificationStatusBeforeLongBreak() {
        let timeBeforeLongBreak = SettingsManager.get(.notifyTimeBeforeLongBreak) as! Int
        let notificationType = SettingsManager.get(.notificationTypeBeforeLongBreak) as! NotificationType
        notifyBeforeLongBreakPopupButton.state = notificationType == .popup || notificationType == .popupAndSound ? .on : .off
        notifyBeforeLongBreakSoundButton.state = notificationType == .sound || notificationType == .popupAndSound ? .on : .off
        timeBeforeLongBreakPopUpButton.selectItem(withTag: timeBeforeLongBreak)
    }
    
    private func updateNotificationStatusAfterLongBreak() {
        let notificationType = SettingsManager.get(.notificationTypeAfterLongBreak) as! NotificationType
        notifyAfterLongBreakSoundButton.state = notificationType == .sound || notificationType == .popupAndSound ? .on : .off
    }
    
    private func updateNotificationStatusBeforeShortBreak() {
        let timeBeforeShortBreak = SettingsManager.get(.notifyTimeBeforeShortBreak) as! Int
        let notificationType = SettingsManager.get(.notificationTypeBeforeShortBreak) as! NotificationType
        notifyBeforeShortBreakPopupButton.state = notificationType == .popup || notificationType == .popupAndSound ? .on : .off
        notifyBeforeShortBreakSoundButton.state = notificationType == .sound || notificationType == .popupAndSound ? .on : .off
        timeBeforeShortBreakPopUpButton.selectItem(withTag: timeBeforeShortBreak)
    }
    
    private func updateNotificationStatusAfterShortBreak() {
        let notificationType = SettingsManager.get(.notificationTypeAfterShortBreak) as! NotificationType
        notifyAfterShortBreakSoundButton.state = notificationType == .sound || notificationType == .popupAndSound ? .on : .off
    }
    
    private func update(setting: Setting, popup: Bool, sound: Bool) {
        let notificationType: NotificationType = popup && sound ? .popupAndSound : popup ? .popup : sound ? .sound : .no
        SettingsManager.set(notificationType.rawValue, for: setting)
    }
}
