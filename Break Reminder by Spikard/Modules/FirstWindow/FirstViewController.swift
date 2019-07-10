//
//  FirstViewController.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 29/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

class FirstViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func okButtonClicked(_ sender: Any) {
        view.window?.close()
    }
}
