//
//  SettingsViewController.swift
//  Break Reminder by Spikard
//
//  Created by maxial on 27/07/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

enum SettingsItem: Int {
    
    case general, notifications, about
}

// MARK: - SettingsViewController

final class SettingsViewController: NSTabViewController {
    
    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()
        tabView.tabViewItem(at: SettingsItem.general.rawValue).image = NSImage(named: NSImage.preferencesGeneralName)
        tabView.tabViewItem(at: SettingsItem.about.rawValue).image = NSImage(named: NSImage.advancedName)
    }
}
