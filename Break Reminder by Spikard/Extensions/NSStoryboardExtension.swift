//
//  NSStoryboardExtension.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 26/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

private let kFirstWindowStoryboard = "FirstWindow"
private let kPopoverStoryboard = "Popover"
private let kShortBreakStoryboard = "ShortBreak"
private let kLongBreakStoryboard = "LongBreak"
private let kSettingsStoryboard = "Settings"

extension NSStoryboard.Name {
    
    static let firstWindow = NSStoryboard.Name(kFirstWindowStoryboard)
    static let popover = NSStoryboard.Name(kPopoverStoryboard)
    static let shortBreak = NSStoryboard.Name(kShortBreakStoryboard)
    static let longBreak = NSStoryboard.Name(kLongBreakStoryboard)
    static let settings = NSStoryboard.Name(kSettingsStoryboard)
}
