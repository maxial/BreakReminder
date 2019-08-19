//
//  AppDelegate.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 25/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa
import ServiceManagement

private let kStatusItemIconName = "StatusItemIcon"
private let kStatusItemIconRedName = "StatusItemIconRed"
private let kLauncherApplicationIdentifier = "com.spikard.break-reminder-launcher"

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // MARK: - Private properties
    
    @IBOutlet private weak var contextMenu: NSMenu!
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    private var shortBreakWindowController: ShortBreakWindowController?
    private var longBreakWindowController: LongBreakWindowController?
    private var settingsWindowController: SettingsWindowController?
    
    // MARK: - Public methods
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupStatusItem()
        setupBreakWindows()
        
        TimerManager.shared.restartTimer()
        TimerManager.shared.restartSessionTimer()
        
        StartupManager.setup()
        StartupManager.showFirstWindowIfNeeded()
    }
    
    func timerDidUpdate() {
        (shortBreakWindowController?.contentViewController as? ShortBreakViewController)?.timerDidUpdate()
        (longBreakWindowController?.contentViewController as? LongBreakViewController)?.timerDidUpdate()
        updateStatusItemTimer()
    }
    
    func sessionTimerDidUpdate() {
        statusItem.button?.image = NSImage(named: NSImage.Name(TimerManager.shared.sessionTimeLeftInSeconds == 0 ? kStatusItemIconRedName : kStatusItemIconName))
    }
    
    func updateStatusItemTimer() {
        let isDisplayTimerOnStatusBar = SettingsManager.get(.isDisplayTimerOnStatusBar) as! Bool
        if isDisplayTimerOnStatusBar {
            let time = " " + TimeConverter.timerString(from: TimerManager.shared.timeLeftInSeconds, truncateHoursIfZero: true)
            statusItem.attributedTitle = NSAttributedString(string: time, attributes: [.font : NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .medium)])
        } else {
            statusItem.attributedTitle = nil
        }
    }
    
    func timeIsUp() {
        switch TimerManager.shared.status {
        case .work:
            shortBreakWindowController?.closeWindow()
            longBreakWindowController?.closeWindow()
        case .shortBreak:
            shortBreakWindowController?.showWindow()
        case .longBreak:
            longBreakWindowController?.showWindow()
        }
    }
    
    func showSettings(_ sender: Any) {
        if settingsWindowController == nil {
            settingsWindowController = SettingsWindowController.instantiate(fromStoryboardNamed: .settings) as? SettingsWindowController
            settingsWindowController?.showWindow(animated: false)
        } else {
            settingsWindowController?.window?.makeKeyAndOrderFront(nil)
        }
        PopoverManager.shared.togglePopover(sender)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    // MARK: - Private methods
    
    private func setupStatusItem() {
        statusItem.button?.image = NSImage(named: NSImage.Name(kStatusItemIconName))
        statusItem.button?.action = #selector(togglePopover(_:))
        statusItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }
    
    private func setupBreakWindows() {
        shortBreakWindowController = ShortBreakWindowController.instantiate(fromStoryboardNamed: .shortBreak) as? ShortBreakWindowController
        longBreakWindowController = LongBreakWindowController.instantiate(fromStoryboardNamed: .longBreak) as? LongBreakWindowController
//        shortBreakWindowController?.window?.backgroundColor = NSColor.windowBackgroundColor.withAlphaComponent(0.85)
//        longBreakWindowController?.window?.backgroundColor = NSColor.windowBackgroundColor.withAlphaComponent(0.93)
    }
    
    @IBAction private func terminate(_ sender: Any) {
        NSApp.terminate(self)
    }
    
    @objc private func togglePopover(_ sender: NSStatusBarButton) {
        guard let eventType = NSApp.currentEvent?.type else { return }
        if eventType == .leftMouseUp {
            PopoverManager.shared.togglePopover(sender)
        } else {
            statusItem.menu = contextMenu
            statusItem.popUpMenu(contextMenu)
            statusItem.menu = nil
        }
    }
}
