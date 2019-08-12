//
//  CATextLayerExtension.swift
//  Break Reminder by Spikard
//
//  Created by maxial on 05/08/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

extension CATextLayer {
    
    var color: NSColor? {
        get { return foregroundColor == nil ? nil : NSColor(cgColor: foregroundColor!) }
        set { foregroundColor = newValue?.cgColor }
    }
    
    convenience init(text: String, fontSize: Double? = nil, color: NSColor? = nil) {
        self.init()
        string = text
        if let fontSize = fontSize {
            self.fontSize = CGFloat(fontSize)
        }
        self.color = color
        implicitAnimations = false
        contentsScale = NSScreen.main?.backingScaleFactor ?? 2
    }
}
