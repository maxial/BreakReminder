//
//  NSFontExtension.swift
//  Spikard - Break Reminder
//
//  Created by maxial on 27/05/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

extension NSFont {
    
    static var timerMonospacedDigitSystemFont: NSFont {
        return NSFont.monospacedDigitSystemFont(ofSize: 35, weight: .thin)
    }
    
    static var sessionTimerMonospacedDigitSystemFont: NSFont {
        return NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .ultraLight)
    }
    
    static var breakTimerMonospacedDigitSystemFont: NSFont {
        return NSFont.monospacedDigitSystemFont(ofSize: 14, weight: .thin)
    }
}
