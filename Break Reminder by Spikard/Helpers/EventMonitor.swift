//
//  EventMonitor.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 26/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

protocol EventMonitorDelegate: class {
    
    func handler(event: NSEvent)
}

// MARK: - EventMonitor

final class EventMonitor {
    
    weak var delegate: EventMonitorDelegate?
    
    // MARK: - Private properties
    
    private var monitor: Any?
    private let mask: NSEvent.EventTypeMask
    
    // MARK: - Public methods
    
    init(mask: NSEvent.EventTypeMask) {
        self.mask = mask
    }
    
    deinit {
        stop()
    }
    
    func start() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }
    
    func stop() {
        guard let monitor = monitor else { return }
        NSEvent.removeMonitor(monitor)
        self.monitor = nil
    }
    
    // MARK: - Private methods
    
    private func handler(event: NSEvent) {
        delegate?.handler(event: event)
    }
}

