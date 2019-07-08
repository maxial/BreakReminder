//
//  StartupManager.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 28/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa
import ServiceManagement

private let kLauncherApplicationIdentifier = "com.spikard.break-reminder-launcher"
private let kStartOnSystemStartupKey = "StartOnSystemStartupKey"
private let kFirstLaunchKey = "FirstLaunchKey"

// MARK: - StartupManager

final class StartupManager {
    
    class var startAppOnSystemStartup: Bool {
        get { return UserDefaults.standard.bool(forKey: kStartOnSystemStartupKey) }
        set { update(startAppOnSystemStartup: newValue) }
    }
    
    class func setup() {
        SMLoginItemSetEnabled(kLauncherApplicationIdentifier as CFString, startAppOnSystemStartup)
        if !NSWorkspace.shared.runningApplications.filter({ $0.bundleIdentifier == kLauncherApplicationIdentifier }).isEmpty {
            DistributedNotificationCenter.default.post(name: .killLauncher, object: Bundle.main.bundleIdentifier!)
        }
    }
    
    class func showFirstWindowIfNeeded() {
        if (!UserDefaults.standard.bool(forKey: kFirstLaunchKey)) {
            guard let firstWindowController = FirstWindowController.instantiate(fromStoryboardNamed: .firstWindow) as? FirstWindowController else { return }
            firstWindowController.showWindow(animated: false)
            UserDefaults.standard.set(true, forKey: kFirstLaunchKey)
        }
    }
    
    // MARK: - Private methods
    
    private class func update(startAppOnSystemStartup: Bool) {
        UserDefaults.standard.set(startAppOnSystemStartup, forKey: kStartOnSystemStartupKey)
        SMLoginItemSetEnabled(kLauncherApplicationIdentifier as CFString, startAppOnSystemStartup)
    }
}
