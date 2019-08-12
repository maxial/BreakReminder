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
    
    @IBOutlet private weak var circularTimer: CircularTimer!
    @IBOutlet private weak var sessionTimerLabel: NSTextField!
    @IBOutlet private weak var shortBreaksStackView: NSStackView!
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func timerDidUpdate() {
        circularTimer?.timeIntervalInSeconds = TimerManager.shared.timeIntervalInSeconds
        circularTimer?.timeLeftInSeconds = TimerManager.shared.timeLeftInSeconds
    }
    
    func sessionTimerDidUpdate() {
        sessionTimerLabel?.stringValue = TimeConverter.string(from: TimerManager.shared.sessionTimeLeftInSeconds)
        sessionTimerLabel?.textColor = TimerManager.shared.sessionTimeLeftInSeconds == 0 ? .systemRed : .secondaryLabelColor
    }
    
    func updateShortBreaksStackView() {
        shortBreaksStackView?.isHidden = !(SettingsManager.get(.isEnabledShortBreaks) as! Bool)
        let numberOfShortBreaks = SettingsManager.get(.numberOfShortBreaks) as! Int
        shortBreaksStackView?.arrangedSubviews.enumerated().forEach { i, view in
            view.isHidden = i >= numberOfShortBreaks
            view.backgroundColor = i < TimerManager.shared.currentShortBreak ? .labelColor : .tertiaryLabelColor
        }
    }
    
    // MARK: - Private methods
    
    private func setup() {
        sessionTimerLabel.font = .sessionTimerMonospacedDigitSystemFont
        timerDidUpdate()
        sessionTimerDidUpdate()
        updateShortBreaksStackView()
    }
    
    @IBAction private func closeButtonClicked(_ sender: Any) {
        PopoverManager.shared.togglePopover(sender)
    }
    
    @IBAction private func quitButtonClicked(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction private func restartButtonClicked(_ sender: Any) {
        TimerManager.shared.restartTimer()
    }
    
    @IBAction private func pauseButtonClicked(_ sender: Any) {
        TimerManager.shared.isPaused = !TimerManager.shared.isPaused
        guard let button = sender as? NSButton else { return }
        button.image = NSImage(named: NSImage.Name(TimerManager.shared.isPaused ? "Play" : "Pause"))
    }
    
    @IBAction private func likeButtonClicked(_ sender: Any) {
        guard let writeReviewURL = URL(string: "https://itunes.apple.com/app/id1465649028?action=write-review") else { return }
        NSWorkspace.shared.open(writeReviewURL)
        PopoverManager.shared.togglePopover(sender)
    }
    
    @IBAction private func settingsButtonTapped(_ sender: Any) {
        (NSApplication.shared.delegate as? AppDelegate)?.showSettings(sender)
    }
}
