//
//  AboutSettingsViewController.swift
//  Break Reminder by Spikard
//
//  Created by maxial on 23/08/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

// MARK: - AboutSettingsViewController

final class AboutSettingsViewController: NSViewController {
    
    // MARK: - Private properties

    @IBOutlet private weak var appNameLabel: NSTextField!
    @IBOutlet private weak var appVersionLabel: NSTextField!
    @IBOutlet private weak var copyrightLabel: NSTextField!
    
    // MARK: - Public methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appNameLabel.stringValue = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
        appVersionLabel.stringValue = NSLocalizedString("Version ", comment: "") + (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)
        copyrightLabel.stringValue = Bundle.main.infoDictionary!["NSHumanReadableCopyright"] as! String
    }
}
