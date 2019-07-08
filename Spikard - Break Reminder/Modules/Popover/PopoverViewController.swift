//
//  PopoverViewController.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 25/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

// MARK: - PopoverViewController

final class PopoverViewController: NSViewController {
    
    // MARK: - Private properties
    
    @IBOutlet private weak var timerTextField: NSTextField!
    @IBOutlet private weak var settingsButton: NSButton!
    
    @IBOutlet private weak var restTimePopupButton: NSPopUpButton!
    @IBOutlet private weak var workingTimePopupButton: NSPopUpButton!
    @IBOutlet private weak var launchAtSystemStartupCheckButton: NSButton!
    
    private var settingsIsVisible: Bool = false
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerTextField.font = NSFont.popoverTimerMonospacedDigitSystemFont
        updateTimerTextField(with: TimerManager.shared.timeLeftInSeconds)
        setupSettingsSection()
        
        NotificationCenter.default.addObserver(self, selector: #selector(tick(notification:)), name: .tick, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private methods
    
    @IBAction private func closeButtonClicked(_ sender: Any) {
        PopoverManager.shared.togglePopover(sender)
    }
    
    @IBAction private func quitButtonClicked(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction private func settingsButtonClicked(_ sender: Any) {
        settingsIsVisible = !settingsIsVisible
        updateSettingsSectionVisibility()
    }
    
    @IBAction private func restartButtonClicked(_ sender: Any) {
        TimerManager.shared.startTimer()
    }
    
    @IBAction private func pauseButtonClicked(_ sender: Any) {
        TimerManager.shared.toggleTimer()
        guard let button = sender as? NSButton else { return }
        button.image = NSImage(named: NSImage.Name(TimerManager.shared.timerIsPaused ? "Play" : "Pause"))
    }
    
    @IBAction private func likeButtonClicked(_ sender: Any) {
        guard let writeReviewURL = URL(string: "https://itunes.apple.com/app/id1465649028?action=write-review") else { return }
        NSWorkspace.shared.open(writeReviewURL)
    }
    
    @IBAction private func restTimeChanged(_ sender: NSPopUpButton) {
        SettingsManager.update(.restTime, withTimeInSeconds: sender.selectedItem?.tag ?? 0)
    }
    
    @IBAction private func workingTimeChanged(_ sender: NSPopUpButton) {
        SettingsManager.update(.workingTime, withTimeInSeconds: sender.selectedItem?.tag ?? 0)
    }
    
    @IBAction func launchAtSystemStartupChanged(_ sender: NSButton) {
        StartupManager.startAppOnSystemStartup = sender.state == .on
    }
    
    private func updateTimerTextField(with timeLeftInSeconds: Int) {
        timerTextField.stringValue = TimeConverter.string(from: TimerManager.shared.timeLeftInSeconds)
    }
    
    private func setupSettingsSection() {
        let restTimeInSeconds = SettingsManager.timeInSeconds(for: .restTime)
        let workingTimeInSeconds = SettingsManager.timeInSeconds(for: .workingTime)
        if let restTimeIndex = restTimePopupButton.itemArray.firstIndex(where: { $0.tag == restTimeInSeconds }) {
            restTimePopupButton.selectItem(at: restTimeIndex)
        }
        if let workingTimeIndex = workingTimePopupButton.itemArray.firstIndex(where: { $0.tag == workingTimeInSeconds }) {
            workingTimePopupButton.selectItem(at: workingTimeIndex)
        }
        launchAtSystemStartupCheckButton.state = StartupManager.startAppOnSystemStartup ? .on : .off
        updateSettingsSectionVisibility()
    }
    
    private func updateSettingsSectionVisibility() {
        settingsButton.title = settingsIsVisible ? NSLocalizedString("Hide settings", comment: "") : NSLocalizedString("Show settings", comment: "")
        restTimePopupButton.superview?.isHidden = !settingsIsVisible
        workingTimePopupButton.superview?.isHidden = !settingsIsVisible
        launchAtSystemStartupCheckButton.superview?.isHidden = !settingsIsVisible
    }
    
    // MARK: - Notifications
    
    @objc private func tick(notification: NSNotification) {
        guard let timeLeftInSeconds = notification.userInfo?[kTimeLeftInSecondsKey] as? Int else { return }
        updateTimerTextField(with: timeLeftInSeconds)
    }
}
