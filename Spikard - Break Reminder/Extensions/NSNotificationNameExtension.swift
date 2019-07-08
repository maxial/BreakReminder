//
//  NSNotificationNameExtension.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 26/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

private let kTickNotification = "TickNotification"
private let kTimeIsUpNotification = "TimeIsUpNotification"
private let kKillLauncherNotification = "KillLauncherNotification"

extension NSNotification.Name {
    
    static let tick = NSNotification.Name(kTickNotification)
    static let timeIsUp = NSNotification.Name(kTimeIsUpNotification)
    static let killLauncher = Notification.Name(kKillLauncherNotification)
}
