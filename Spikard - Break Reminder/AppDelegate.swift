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
private let kLauncherApplicationIdentifier = "com.spikard.break-reminder-launcher"

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // MARK: - Private properties
    
    @IBOutlet private weak var contextMenu: NSMenu!
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    // MARK: - Public properties
    
    var restTimeWindowController: RestTimeWindowController?
    
    // MARK: - Public methods
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupStatusItem()
        TimerManager.shared.startTimer()
        restTimeWindowController = RestTimeWindowController.instantiate(fromStoryboardNamed: .restTime) as? RestTimeWindowController
        NotificationCenter.default.addObserver(self, selector: #selector(timeIsUp(notification:)), name: .timeIsUp, object: nil)
        StartupManager.setup()
        StartupManager.showFirstWindowIfNeeded()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private methods
    
    @IBAction private func terminate(_ sender: Any) {
        NSApp.terminate(self)
    }
    
    private func setupStatusItem() {
        statusItem.button?.image = NSImage(named: NSImage.Name(kStatusItemIconName))
        statusItem.button?.action = #selector(togglePopover(_:))
        statusItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
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
    
    @objc private func timeIsUp(notification: NSNotification) {
        guard let restTimeWindowController = restTimeWindowController else { return }
        switch TimerManager.shared.status {
        case .workingTime:  restTimeWindowController.closeWindow()
        case .restTime:     restTimeWindowController.showWindow()
        }
    }
}
