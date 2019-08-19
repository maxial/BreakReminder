//
//  CircularTimer.swift
//  Break Reminder by Spikard
//
//  Created by maxial on 05/08/2019.
//  Copyright © 2019 Spikard. All rights reserved.
//

import Cocoa

// MARK: - CircularTimer

@IBDesignable
public final class CircularTimer: NSView {
    
    // MARK: - Public properties
    
    @IBInspectable public var timeIntervalInSeconds = 0 { didSet { updateProgress() } }
    @IBInspectable public var timeLeftInSeconds = 0 { didSet { updateProgress() } }
    @IBInspectable public var highlightedLineWidth: CGFloat = 2
    
    // MARK: - Private properties
    
    private var trackCircle: CAShapeLayer?
    private var highlightedCircle: ProgressCircleShapeLayer?
    private var timerLabel: CATextLayer?
    
    // MARK: - Public methods
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    public func start(with timeInSeconds: Int) {
        timeIntervalInSeconds = timeInSeconds
        timeLeftInSeconds = timeInSeconds
    }
    
    public override func updateLayer() {
        trackCircle?.fillColor = nil
        trackCircle?.strokeColor = NSColor.tertiaryLabelColor.cgColor
        highlightedCircle?.strokeColor = NSColor.labelColor.cgColor
        timerLabel?.color = NSColor.labelColor
    }
    
    // MARK: - Private methods
    
    private func setup() {
        wantsLayer = true
        
        let radius = (bounds.width < bounds.height ? bounds.midX : bounds.midY) - highlightedLineWidth
        
        trackCircle = CAShapeLayer.circle(radius: Double(radius), center: bounds.center)
        trackCircle!.frame = bounds
        trackCircle!.lineWidth = highlightedLineWidth / 2
        layer?.addSublayer(trackCircle!)
        
        highlightedCircle = ProgressCircleShapeLayer(radius: Double(radius), center: bounds.center)
        highlightedCircle!.lineWidth = highlightedLineWidth
        layer?.addSublayer(highlightedCircle!)
        
        timerLabel = CATextLayer(text: TimeConverter.timerString(from: timeIntervalInSeconds))
        timerLabel!.fontSize = bounds.width < bounds.height ? bounds.width * 0.2 : bounds.height * 0.2
        timerLabel!.frame = CGRect(x: 0, y: 0, width: bounds.width, height: timerLabel!.preferredFrameSize().height)
        timerLabel!.position = CGPoint(x: bounds.midX, y: bounds.midY)
        timerLabel!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        timerLabel!.alignmentMode = .center
        timerLabel!.font = NSFont.timerMonospacedDigitSystemFont
        layer?.addSublayer(timerLabel!)
    }
    
    private func updateProgress() {
        highlightedCircle?.progress = (Double(timeLeftInSeconds) / Double(timeIntervalInSeconds)).clamped(to: 0...1)
        timerLabel?.string = TimeConverter.timerString(from: timeLeftInSeconds)
    }
}
