//
//  SettingsViewController.swift
//  Break Reminder by Spikard
//
//  Created by maxial on 27/07/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

// MARK: - SettingsViewController

final class SettingsViewController: NSTabViewController {
    
    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()
        tabView.tabViewItem(at: 0).image = NSImage(named: NSImage.preferencesGeneralName)
    }
    
//    override func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
//        var arr = super.toolbarDefaultItemIdentifiers(toolbar)
//        arr.insert(NSToolbarItem.Identifier.flexibleSpace, at: 0)
//        arr.append(NSToolbarItem.Identifier.flexibleSpace)
//        return arr
//    }
}
