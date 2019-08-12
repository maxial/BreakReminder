//
//  BreakWindowController.swift
//  Break Reminder by Spikard
//
//  Created by maxial on 09/08/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

class BreakWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        window?.isOpaque = false
        window?.level = .screenSaver
        window?.setFrame(NSScreen.main!.frame, display: true)
    }
}
