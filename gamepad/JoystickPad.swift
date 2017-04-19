//
//  Joystick.swift
//  JoystickTest
//
//  Created by pr0ximo on 2016. 12. 13..
//  Copyright © 2016년 pr0ximo. All rights reserved.
//

import UIKit

protocol JoystickPadDelegate {
    func joystickPadMove(_ ox: Float, _ oy: Float, _ angle: Float)
    func joystickPadRelease()
}

@IBDesignable
class JoystickPad: UIView {
    @IBOutlet weak var delegate: AnyObject?
    @IBInspectable var padColor: UIColor = UIColor.clear
    
    private var PadSize: Int = 80
    private var RoundSize: CGFloat = 160
    
    private var stick: UIView?
    private var gesture: UIPanGestureRecognizer?
    
    func panGesture(_ sender: UIPanGestureRecognizer) {
        func angle(x: Double, y: Double) -> Double {
            if x > 0 && y >= 0 {
                return atan(y / x)
            } else if x > 0 && y < 0 {
                return atan(y / x) + 2 * Double.pi
            } else if x < 0 {
                return atan(y / x) + Double.pi
            } else if x == 0 && y > 0 {
                return (Double.pi / 2.0)
            } else if x == 0 && y < 0 {
                return ((3.0 * Double.pi) / 2)
            }
            
            return 0.0
        }
        
        if sender.state == .ended {
            (delegate as? JoystickPadDelegate)?.joystickPadRelease()
            sender.view!.center = CGPoint(x: RoundSize / 2, y: RoundSize / 2)
            return
        }
        
        let translation = sender.translation(in: self)
        let r = (RoundSize / 2) - (CGFloat(PadSize) / 2)
        var x = sender.view!.center.x + translation.x
        var y = sender.view!.center.y + translation.y
        let angle_value = angle(x: Double(x - (RoundSize / 2)), y: Double(y - (RoundSize / 2)))
        
        if pow(x - (RoundSize / 2), 2) > pow(r, 2) - pow(y - (RoundSize / 2), 2) {
            let new_x = Double(r) * cos(angle_value)
            x = CGFloat(new_x) + (RoundSize / 2)
        }
        
        if pow(y - (RoundSize / 2), 2) > pow(r, 2) - pow(x - (RoundSize / 2), 2) {
            let new_y = Double(r) * sin(angle_value)
            y = CGFloat(new_y) + (RoundSize / 2)
        }
        
        sender.view!.center = CGPoint(x: x, y: y)
        sender.setTranslation(.zero, in: self)
        
        (delegate as? JoystickPadDelegate)?.joystickPadMove(Float(x) - (Float(RoundSize) / 2), -(Float(y) - (Float(RoundSize) / 2)), 360 - (Float(angle_value) * 57.2958))
    }
    
    private func setup() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.size.width / 2.0
        //self.backgroundColor = backgroundColor!
        
        stick = UIView(frame: CGRect(x: 0, y: 0, width: PadSize, height: PadSize))
        stick?.isUserInteractionEnabled = true
        stick?.center = CGPoint(x: RoundSize / 2, y: RoundSize / 2)
        stick?.layer.cornerRadius = (stick?.bounds.size.width)! / 2.0
        stick?.backgroundColor = padColor
        self.addSubview(stick!)
        
        gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        stick?.addGestureRecognizer(gesture!)
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    deinit {
        stick?.removeGestureRecognizer(gesture!)
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        setup()
    }
}
