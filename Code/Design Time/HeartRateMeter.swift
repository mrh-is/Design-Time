//
//  HeartRateMeter.swift
//  Motiv Demo
//
//  Created by Michael Helmbrecht on 7/17/14.
//  Copyright (c) 2014 Motiv. All rights reserved.
//

import UIKit
import QuartzCore

private let PulseScale: CGFloat = 1.05

@IBDesignable
public class HeartRateMeter: UIView {
    
    @IBInspectable public var circleColor: UIColor = UIColor.darkGrayColor() {
        didSet {
            self.backgroundView.backgroundColor = self.circleColor
        }
    }
    
    @IBInspectable public var textColor: UIColor = UIColor.darkGrayColor() {
        didSet {
            self.valueLabel.textColor = self.textColor
            self.unitLabel.textColor = self.textColor
        }
    }

    public var heartRate: Int? {
        didSet {
            if let heartRate = self.heartRate {
                self.valueLabel.text = "\(heartRate)"
                if heartRate > 0 && self.heartbeatTimer == nil {
                    self.doHeartbeat()
                }
                else if let oldValue = oldValue {
                    if oldValue < heartRate {
                        self.heartbeatTimer?.invalidate()
                        self.doHeartbeat()
                    }
                }
            }
            else {
                self.valueLabel.text = "--"
                self.heartbeatTimer?.invalidate()
                self.heartbeatTimer = nil
            }
        }
    }
    private var heartbeatTimer: NSTimer?
    
    private var valueLabel: UILabel = UILabel()
    private var unitLabel: UILabel = UILabel()
    private var icon: UIImageView = UIImageView(image: UIImage(named: "heartrate"))
    private var backgroundView: UIView = UIView()
    
    convenience override init() {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required public init(coder: NSCoder)  {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.backgroundView.backgroundColor = self.backgroundColor
        self.addSubview(self.backgroundView)
        self.backgroundView.alignCenterWithView(self)
        self.backgroundView.alignAttribute(.Width, toAttribute: .Height, ofView: self.backgroundView, predicate: "*1")
        self.backgroundView.constrainWidthToView(self, predicate: "<=*\(1/PulseScale),*1@750")
        self.backgroundView.constrainHeightToView(self, predicate: "<=*\(1/PulseScale),*1@750")
        
        self.valueLabel.font = UIFont(name: "Avenir", size: 42)
        self.valueLabel.textAlignment = .Center
        self.backgroundView.addSubview(self.valueLabel)
        self.valueLabel.alignCenterYWithView(self.backgroundView, predicate: "*0.8")
        self.valueLabel.alignLeading("0", trailing: "0", toView: self.backgroundView)
        
        self.unitLabel.text = "bpm"
        self.unitLabel.font = UIFont(name: "Avenir", size: 16)
        self.backgroundView.addSubview(self.unitLabel)
        self.unitLabel.alignCenterXWithView(self.backgroundView, predicate: "*1.2")
        self.unitLabel.alignCenterYWithView(self.backgroundView, predicate: "*1.4")
        
        self.backgroundView.addSubview(self.icon)
        self.icon.alignCenterXWithView(self.backgroundView, predicate: "*0.65")
        self.icon.alignCenterYWithView(self.unitLabel, predicate: nil)
        self.icon.constrainHeightToView(self.backgroundView, predicate: "*0.15")
        self.icon.alignAttribute(.Width, toAttribute: .Height, ofView: self.icon, predicate: "*\(30/28)")
        
        self.heartRate = nil
    }
    
    override public func prepareForInterfaceBuilder() {
        self.heartRate = 95
        self.icon.backgroundColor = self.textColor
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView.layer.cornerRadius = min(self.frame.height/2/PulseScale, self.frame.width/2/PulseScale)
        self.valueLabel.font = UIFont(name: "Avenir", size: 42/100*min(backgroundView.frame.height, backgroundView.frame.width))
        self.unitLabel.font = UIFont(name: "Avenir", size: 16/100*min(self.backgroundView.frame.height, self.backgroundView.frame.width))
    }

    internal func doHeartbeat() {
        if let heartRate = self.heartRate {
            if heartRate > 0 {
                self.doPulse()
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(15.0 / CGFloat(heartRate) * CGFloat(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                    self.doPulse()
                }
                self.heartbeatTimer = NSTimer.scheduledTimerWithTimeInterval(60.0 / NSTimeInterval(heartRate), target: self, selector: "doHeartbeat", userInfo: nil, repeats: false)
            }
        }
    }
    
    private func doPulse() {
        let layer = CALayer()
        layer.cornerRadius = self.backgroundView.frame.height/2
        layer.backgroundColor = self.circleColor.CGColor
        layer.frame = self.backgroundView.bounds
        
        let duration = 0.15
        
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.toValue = PulseScale
        pulseAnimation.fromValue = 1.0
        pulseAnimation.duration = duration
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        layer.addAnimation(pulseAnimation, forKey: "scale")
        
        self.backgroundView.layer.insertSublayer(layer, atIndex: 0)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(duration * 2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            layer.removeFromSuperlayer()
        }
    }
    
    
}
