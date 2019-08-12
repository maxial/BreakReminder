//
//  FirstWindowController.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 29/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

final class FirstWindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()
        guard let window = window else { return }
        window.setFrameOrigin(NSPoint(x: (NSScreen.main!.frame.width - window.frame.width) / 2, y: (NSScreen.main!.frame.height - window.frame.height) / 2))
    }
}
