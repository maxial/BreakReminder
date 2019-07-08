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
private let kResTimeStoryboard = "RestTime"

extension NSStoryboard.Name {
    
    static let firstWindow = NSStoryboard.Name(kFirstWindowStoryboard)
    static let popover = NSStoryboard.Name(kPopoverStoryboard)
    static let restTime = NSStoryboard.Name(kResTimeStoryboard)
}
