//
//  PopoverManager.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 26/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

// MARK: - PopoverManager

final class PopoverManager {
    
    static let shared = PopoverManager()
    
    // MARK: - Private properties
    
    private let popover: NSPopover
    private let eventMonitor: EventMonitor
    
    // MARK: - Public properties
    
    var popoverViewController: PopoverViewController? { return popover.contentViewController as? PopoverViewController }
    
    // MARK: - Public methods
    
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    // MARK: - Private methods
    
    private init() {
        popover = NSPopover()
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown])
        popover.contentViewController = PopoverViewController.instantiate(fromStoryboardNamed: .popover)
        eventMonitor.delegate = self
    }
    
    private func showPopover(sender: Any?) {
        guard let view = sender as? NSView else { return }
        popover.show(relativeTo: view.bounds, of: view, preferredEdge: NSRectEdge.minY)
        (popover.contentViewController as? PopoverViewController)?.timerDidUpdate()
        (popover.contentViewController as? PopoverViewController)?.sessionTimerDidUpdate()
        eventMonitor.start()
    }
    
    private func closePopover(sender: Any?) {
        popover.performClose(sender)
        eventMonitor.stop()
    }
}

// MARK: - EventMonitorDelegate

extension PopoverManager: EventMonitorDelegate {
    
    func handler(event: NSEvent) {
        if popover.isShown {
            closePopover(sender: event)
        }
    }
}
