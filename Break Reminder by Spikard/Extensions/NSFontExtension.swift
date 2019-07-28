//
//  NSFontExtension.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 27/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

extension NSFont {
    
    static var popoverTimerMonospacedDigitSystemFont: NSFont {
        return NSFont.monospacedDigitSystemFont(ofSize: 50, weight: .ultraLight)
    }
    
    static var popoverTotalTimerMonospacedDigitSystemFont: NSFont {
        return NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .ultraLight)
    }
    
    static var restViewTimerMonospacedDigitSystemFont: NSFont {
        return NSFont.monospacedDigitSystemFont(ofSize: 14, weight: .thin)
    }
}
