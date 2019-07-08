//
//  NSViewExtension.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 27/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

@IBDesignable
extension NSView {
    
    var mainLayer: CALayer? {
        get {
            if layer == nil {
                wantsLayer = true
                shadow = NSShadow()
            }
            return layer
        }
    }
    
    @IBInspectable var backgroundColor: NSColor? {
        get { return layer?.backgroundColor != nil ? NSColor(cgColor: layer!.backgroundColor!) : nil }
        set { mainLayer?.backgroundColor = newValue?.cgColor }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer?.cornerRadius ?? 0 }
        set { mainLayer?.cornerRadius = newValue }
    }
    
    @IBInspectable var shadowColor: NSColor? {
        get { return layer?.shadowColor != nil ? NSColor(cgColor: layer!.shadowColor!) : nil }
        set { mainLayer?.shadowColor = newValue?.cgColor }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get { return layer?.shadowRadius ?? 0 }
        set { mainLayer?.shadowRadius = newValue }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get { return layer?.shadowOffset ?? CGSize.zero }
        set { mainLayer?.shadowOffset = newValue }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get { return layer?.shadowOpacity ?? 0 }
        set { mainLayer?.shadowOpacity = newValue }
    }
}
