//
//  RestTimeWindowController.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 26/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

private let kShowAnimationDuration = 7.0
private let kCloseAnimationDuration = 0.0

final class RestTimeWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        window?.isOpaque = false
        window?.backgroundColor = NSColor.secondaryLabelColor
        window?.level = .screenSaver
        window?.setFrame(NSScreen.main!.frame, display: true)
    }
}
