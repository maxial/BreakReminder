//
//  AppDelegate.swift
//  Spikard - Break Reminder Launcher
//
//  Created by maxial on 27/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        StartupManager.setup()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func terminate() {
        NSApp.terminate(nil)
    }
}

