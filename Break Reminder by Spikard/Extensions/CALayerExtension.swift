//
//  CALayerExtension.swift
//  Break Reminder by Spikard
//
//  Created by maxial on 09/08/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

extension CALayer {
    
    var implicitAnimations: Bool {
        get { return actions == nil }
        set { actions = newValue ? nil : ["contents": NSNull()] }
    }
    
    static func withoutImplicitAnimations(closure: () -> Void) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        closure()
        CATransaction.commit()
    }
}
