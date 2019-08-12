//
//  NSBezierPathExtension.swift
//  Break Reminder by Spikard
//
//  Created by maxial on 09/08/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

extension NSBezierPath {
    
    var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        
        for index in 0..<elementCount {
            let type = element(at: index, associatedPoints: &points)
            switch type {
            case .moveTo:
                path.move(to: points[0])
            case .lineTo:
                path.addLine(to: points[0])
            case .curveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePath:
                path.closeSubpath()
            @unknown default:
                assertionFailure("NSBezierPath received a new enum case. Please handle it.")
            }
        }
        
        return path
    }
    
    convenience init(roundedRect rect: CGRect, cornerRadius: CGFloat) {
        self.init(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius)
    }
    
    static func circle(radius: Double, center: CGPoint, startAngle: Double = 0, endAngle: Double = 360) -> Self {
        let path = self.init()
        path.appendArc(withCenter: center, radius: CGFloat(radius), startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle))
        return path
    }
    
    static func progressCircle(radius: Double, center: CGPoint) -> Self {
        let startAngle: CGFloat = 90
        let path = self.init()
        path.appendArc(withCenter: center, radius: CGFloat(radius), startAngle: startAngle, endAngle: startAngle - 360, clockwise: true)
        return path
    }
}
