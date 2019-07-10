//
//  NSWindowControllerExtension.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 26/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

private let kShowAnimationDuration = 7.0
private let kCloseAnimationDuration = 0.0

extension NSWindowController {
    
    class func instantiate(fromStoryboardNamed storyboardName: NSStoryboard.Name) -> NSWindowController {
        let storyboard = NSStoryboard(name: storyboardName, bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(String(describing: self))
        return storyboard.instantiateController(withIdentifier: identifier) as! NSWindowController
    }
    
    func showWindow(animated: Bool = true, completion: (() -> Void)? = nil) {
        window?.makeKeyAndOrderFront(nil)
        if animated {
            window?.alphaValue = 0.0
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = kShowAnimationDuration
                window?.animator().alphaValue = 1.0
            }, completionHandler: {
                completion?()
            })
        } else {
            window?.alphaValue = 1.0
        }
        
    }
    
    func closeWindow(animated: Bool = true) {
        if animated {
            window?.alphaValue = 1.0
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = kCloseAnimationDuration
                window?.animator().alphaValue = 0.0
            }, completionHandler: { [weak self] in
                self?.close()
            })
        } else {
            close()
        }
    }
}
