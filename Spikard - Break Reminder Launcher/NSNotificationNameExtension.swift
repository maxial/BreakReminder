//
//  NSNotificationNameExtension.swift
//  Spikard - Break Reminder Launcher
//
//  Created by maxial on 27/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

private let kKillLauncherNotification = "KillLauncherNotification"

extension NSNotification.Name {
    
    static let killLauncher = Notification.Name(kKillLauncherNotification)
}
