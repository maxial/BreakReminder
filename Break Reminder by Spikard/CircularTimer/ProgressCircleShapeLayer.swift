//
//  ProgressCircleShapeLayer.swift
//  Break Reminder by Spikard
//
//  Created by maxial on 09/08/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

// MARK: - ProgressCircleShapeLayer

final class ProgressCircleShapeLayer: CAShapeLayer {
    
    convenience init(radius: Double, center: CGPoint) {
        self.init()
        fillColor = nil
        lineCap = .round
        path = NSBezierPath.progressCircle(radius: radius, center: center).cgPath
        strokeEnd = 0
    }
    
    var progress: Double {
        get { return Double(strokeEnd) }
        set { strokeEnd = CGFloat(newValue) }
    }
    
    func resetProgress() {
        strokeEnd = 0
    }
}
