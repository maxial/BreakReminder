//
//  StartupManager.swift
//  Spikard - Break Reminder Launcher
//
//  Created by maxial on 28/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

private let kMainApplicationIdentifier = "com.spikard.break-reminder"

final class StartupManager {
    
    // MARK: - Public methods
    
    class func setup() {
        if NSWorkspace.shared.runningApplications.filter({ $0.bundleIdentifier == kMainApplicationIdentifier }).isEmpty {
            DistributedNotificationCenter.default.addObserver(self, selector: #selector(terminate), name: .killLauncher, object: kMainApplicationIdentifier)
        
            let path = Bundle.main.bundlePath as NSString
            var components = path.pathComponents
            components.removeLast()
            components.removeLast()
            components.removeLast()
            components.removeLast()
            let newPath = NSString.path(withComponents: components)
            NSWorkspace.shared.launchApplication(newPath)
        } else {
            terminate()
        }
    }
    
    // MARK: - Private methods
    
    @objc private class func terminate() {
        NSApplication.shared.terminate(self)
    }
}
