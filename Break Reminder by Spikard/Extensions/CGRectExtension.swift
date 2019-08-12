//
//  CGRectExtension.swift
//  Break Reminder by Spikard
//
//  Created by maxial on 09/08/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

extension CGRect {
    
    var center: CGPoint {
        get { return CGPoint(x: midX, y: midY) }
        set { origin = CGPoint(x: newValue.x - (size.width / 2), y: newValue.y - (size.height / 2)) }
    }
}
