//
//  NSViewControllerExtension.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 25/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

extension NSViewController {
    
    class func instantiate(fromStoryboardNamed storyboardName: NSStoryboard.Name) -> NSViewController {
        let storyboard = NSStoryboard(name: storyboardName, bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(String(describing: self))
        return storyboard.instantiateController(withIdentifier: identifier) as! NSViewController
    }
}
