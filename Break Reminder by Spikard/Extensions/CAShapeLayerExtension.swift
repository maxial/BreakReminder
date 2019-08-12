//
//  CAShapeLayerExtension.swift
//  Break Reminder by Spikard
//
//  Created by maxial on 09/08/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

extension CAShapeLayer {
    
    static func circle(radius: Double, center: CGPoint) -> Self {
        let layer = self.init()
        layer.path = NSBezierPath.circle(radius: radius, center: center).cgPath
        return layer
    }
    
    convenience init(path: NSBezierPath) {
        self.init()
        self.path = path.cgPath
    }
}
